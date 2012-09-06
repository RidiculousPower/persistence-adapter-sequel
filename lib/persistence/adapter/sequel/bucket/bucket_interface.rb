
module ::Persistence::Adapter::Sequel::Bucket::BucketInterface

  include ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString

  ## Consider using nested sets
  #include ::Persistence::Adapter::KyotoCabinet::DatabaseSupport
  #acts_as_nested_set
  attr_accessor :parent_adapter, :name

  # we're always opening as writers and creating the files if they don't exist

  ################
  #  initialize  #
  ################
  
  def initialize( parent_adapter, bucket_name )


    @indexes = {}
      
    @parent_adapter = parent_adapter
    @name = bucket_name.to_s
    
    # bucket database corresponding to self - holds properties
    #     # objectID             => klass
    # objectID.property_A  => property_value_A
    # objectID.property_B  => property_value_B
    #
    parent_adapter.db.create_table?(bucket_name) do
      Integer :global_id
      Text    :key   #key
      Text    :value  #value
    end
    @database__bucket = parent_adapter.db[bucket_name]
  
    # holds IDs that are presently in this bucket so we can iterate objects normally
    # 
    # objectID => objectID
    #
    parent_adapter.db.create_table?(table__ids_in_bucket_database) do
      Integer :global_id
    end
    @database__ids_in_bucket = parent_adapter.db[table__ids_in_bucket_database]
    
    # holds whether each index permits duplicates
    parent_adapter.db.create_table?(table__index_permits_duplicates_database) do
      String :index_name
      TrueClass :duplicate #Maps to boolean
    end
    @database__index_permits_duplicates = parent_adapter.db[table__index_permits_duplicates_database]
  end

  ###########
  #  count  #
  ###########
  
  def count
    
    @database__ids_in_bucket.count
    
  end
  
  ###########
  #  close  #
  ###########
  
  def close

    close_indexes

    @database__index_permits_duplicates.close

    super

  end

  ###################
  #  close_indexes  #
  ###################
  
  def close_indexes

    @indexes.each do |this_index_name, this_index_instance|
      this_index_instance.close
    end

  end

  ############
  #  cursor  #
  ############

  def cursor
    ::Persistence::Adapter::Sql::Cursor.new( self, nil, @database__ids_in_bucket.cursor )
  end

  #########################
  #  permits_duplicates?  #
  #########################
  
  def permits_duplicates?( index )

    permits_duplicates = nil#@database__index_permits_duplicates.fetch("SELECT #{@database__index_permits_duplicates.filter(:index_name => index).exists}").single_value #there maybe a better way
    
    permits_duplicates

  end

  #################
  #  put_object!  #
  #################
  
  def put_object!( object )
    
    #Be sure that the object has a truely unique id.
    @parent_adapter.ensure_object_has_globally_unique_id( object )

    # insert ID to cursor index
    @database__ids_in_bucket.insert(:global_id => object.persistence_id ) unless @database__ids_in_bucket.get(:global_id => object.persistence_id)#not so sure about this line...

    @database__bucket.insert(:global_id => object.persistence_id, :key => :klass.to_s, :value => Marshal::dump(object.class))
    # insert properties
    object.persistence_hash_to_port.each do |primary_key, attribute_value|
      put_attribute!(  object, primary_key.to_sym, attribute_value )
    end
    
    object.persistence_id
    
  end
  
  ################
  #  get_object  #
  ################
  
  def get_object( global_id )

    object_persistence_hash = { }

    # create sub dataset of all column with ID
    # First record (ID only, no attribute) points to klass, so exclude it from listed records.
    object_properties = @database__bucket.where(:global_id => global_id).exclude(:key => :klass.to_s).all 
        # Iterate until dataset is empty.

    unless object_properties.nil?

      object_properties.each do |row|
        
          object_persistence_hash[ primary_key_to_attribute_name( row[:key] ) ] = Marshal::load(row[:value]) unless row[:key].nil?
          
      end

    end

    object_persistence_hash.empty? ? nil : object_persistence_hash
    
  end
  
  ####################
  #  delete_object!  #
  ####################
  
  def delete_object!( global_id )

    # delete from IDs in bucket database
    @database__ids_in_bucket.where(:global_id => global_id ).delete

    # delete all rows with ID in bucket database
    @database__bucket.where(:global_id => global_id ).delete
  
  end
  
  ####################
  #  put_attribute!  #
  ####################
  
  def put_attribute!(object, attribute_name, value )

    @database__bucket.insert(:global_id => object.persistence_id, :key => attribute_name.to_s, :value => Marshal::dump(value))
    
  end

  ###################
  #  get_attribute  #
  ###################
  
  def get_attribute( object, attribute_name )

    value = nil

    if serialized_value = @database__bucket.where(:global_id => object.persistence_id, :key => attribute_name.to_s).get(:value)

      value = Marshal::load(serialized_value )

    end

    value

  end
  
  #######################
  #  delete_attribute!  #
  #######################
  
  def delete_attribute!( object, attribute_name )

    # delete primary info on attribute
    @database__bucket.where(:global_id => object.persistence_id, :key => attribute_name ).delete

  end

  ##################
  #  create_index  #
  ##################
  
  def create_index( index_name, permits_duplicates )

    # make sure index doesn't already exist with conflict duplicate permission
    unless ( permits_duplicates_value = permits_duplicates?( index_name ) ).nil?
      if ! permits_duplicates_value != ! permits_duplicates
        raise 'Index on :' + index_name.to_s + ' already exists and ' + 
              ( permits_duplicates ? 'does not permit' : 'permits' ) + ' duplicates, which conflicts.'
      end

    else

      @database__index_permits_duplicates.insert(:index_name => index_name.to_s, :duplicate => permits_duplicates )

    end

    # create/instantiate the index
    index_instance = self.class::Index.new( index_name, self, permits_duplicates )

    # store index instance
    @indexes[ index_name ] = index_instance

    index_instance
    
  end

  ###########
  #  index  #
  ###########
  
  def index( index_name )

    @indexes[ index_name ]

  end

  ##################
  #  delete_index  #
  ##################
  
  def delete_index( index_name )

    # remove index table
    @parent_adapter.db.drop_table?(index_name)

    index_instance = @indexes.delete( index_name )
    
    index_instance.delete
    
  end
  
  ################
  #  has_index?  #
  ################
  
  def has_index?( index_name )
    
    @indexes.has_key?( index_name )

  end

  ###############
  #  get_class  #
  ###############

  def get_class( global_id )
    
    klass = nil

    if klass_serilized_name = @database__bucket.where( :global_id => global_id.to_s, :key => :klass.to_s ).get(:value)
      
      klass = Marshal::load(klass_serilized_name)
          
    end
 
    klass
    
  end

  ###############
  #  get_class  #
  ###############

  def delete_class( global_id )
    
    @database__bucket.( global_id ).delete

  end
  
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ###################################
  #  primary_key_to_property_name  #
  ###################################

  def primary_key_to_attribute_name( primary_key )


    this_global_id, this_attribute = primary_key.split( @parent_adapter.class::Delimiter ) unless primary_key.nil?
    
    this_attribute.to_sym if this_attribute

  end
  
  ##################################
  #  table__ids_in_bucket_database  #
  ##################################

  def table__ids_in_bucket_database()

    (@name.to_s + '_ids_in_bucket').to_sym

  end  

  #############################################
  #  table__index_permits_duplicates_database  #
  #############################################

  def table__index_permits_duplicates_database()
    
    (@name.to_s + '_index_permits_duplicates').to_sym

  end

end
