module ::Persistence::Adapter::Sql::AdapterInterface

  include ::Persistence::Adapter::Abstract::EnableDisable
  
  attr_reader :db

  ################
  #  initialize  #
  ################

  ##
  # For now replicate Sequel call. See public method Sequel.connect().
  #
  def initialize( connection_string, connection_options = {} )

    #Calling super would be inappropriate here 
    @connection_string = connection_string
    @connection_options = connection_options

    @buckets = { }

  end
  
  ############
  #  enable  #
  ############

  def enable

    super
    # Connect to an in-memorry database
    @db = ::Sequel.connect(@connection_string, @connection_options)
    

    # holds global ID => primary bucket
    @db.create_table?(:PrimaryBucketForID) do
      primary_key :global_id
      String :bucket_name, :null => false
    end
    @database__primary_bucket_for_id = @db[:PrimaryBucketForID]

    return self

  end
  
  #############
  #  disable  #
  #############
  
  def disable

    super

    @db.disconnect
    
    return self

  end
  
  ########################
  #  persistence_bucket  #
  ########################

  def persistence_bucket( bucket_name )
    
    bucket_instance = nil

    unless bucket_instance = @buckets[ bucket_name ]
      bucket_instance = ::Persistence::Adapter::Sql::Bucket.new(self, bucket_name )
      @buckets[ bucket_name ] = bucket_instance
    end

    return bucket_instance

  end
  
  
    ###################################
  #  get_bucket_name_for_object_id  #
  ###################################

  def get_bucket_name_for_object_id( global_id )

    bucket_name = @database__primary_bucket_for_id.where(:global_id => global_id ).get(:bucket_name)

    bucket_name = bucket_name if bucket_name

    return bucket_name.to_sym

  end

  #############################
  #  get_class_for_object_id  #
  #############################

  def get_class_for_object_id( global_id )

    bucket_name = get_bucket_name_for_object_id( global_id )

    bucket_instance = persistence_bucket( bucket_name )

    return bucket_instance.get_class( global_id )

  end

  #################################
  #  delete_bucket_for_object_id  #
  #################################

  def delete_bucket_for_object_id( global_id )

    return @database__primary_bucket_for_id.remove( global_id )

  end

  ################################
  #  delete_class_for_object_id  #
  ################################

  def delete_class_for_object_id( global_id )

    bucket_name = get_bucket_name_for_object_id( global_id )

    bucket_instance = persistence_bucket( bucket_name )

    return bucket_instance.delete_class( global_id )

  end

  ##########################################
  #  ensure_object_has_globally_unique_id  #
  ##########################################

  def ensure_object_has_globally_unique_id( object )

    name = object.persistence_bucket.name.to_s 

    unless object.persistence_id

      # we only store one sequence so we don't need a key; increment it by 1
      # and write it to our global object database with a bucket/key struct as data    
      
      # Currenly this is handled by sql autoincrementing primary keys
      @database__primary_bucket_for_id.insert(:bucket_name => name)

      object.persistence_id = @database__primary_bucket_for_id.where(:bucket_name => name).get(:global_id)

    end

    return self

  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ################################
  #  file__id_sequence_database  #
  ################################

  def file__id_sequence_database

    return File.join( home_directory,
                      'IDSequence' + extension__id_sequence_database )

  end

  ##########################################
  #  file__primary_bucket_for_id_database  #
  ##########################################

  def file__primary_bucket_for_id_database

    return File.join( home_directory,
                      'PrimaryBucketForID' + extension__primary_bucket_for_id_database )

  end

  #####################################
  #  extension__id_sequence_database  #
  #####################################

  def extension__id_sequence_database

    return extension__database( :tree )

  end

  ###############################################
  #  extension__primary_bucket_for_id_database  #
  ###############################################

  def extension__primary_bucket_for_id_database

    return extension__database( :hash )

  end

end