

module ::Persistence::Adapter::Sequel::Bucket::Index::IndexInterface

  ################
  #  initialize  #
  ################

  def initialize( index_name, parent_bucket, permits_duplicates )

    @name = index_name

    @parent_bucket = parent_bucket

    @permits_duplicates = permits_duplicates

    # get path info for index databases
    bucket_name    = @bucket_name

    parent_bucket.parent_adapter.db.create_table?(table__index_database) do
      Integer :global_id
      Text :key
    end
    @database__index = parent_bucket.parent_adapter.db[table__index_database]

    parent_bucket.parent_adapter.db.create_table?(file__reverse_index_database) do
      Integer :global_id
      Text :key
    end
    @database__reverse_index = parent_bucket.parent_adapter.db[file__reverse_index_database]

  end

  ###########
  #  count  #
  ###########
  
  def count
    
    return @database__index.count
    
  end

  ###########
  #  close  #
  ###########
  
  def close
    
    @database__index.close
    @database__reverse_index.close

  end
  
  ############
  #  delete  #
  ############
  
  def delete
    
    # remove index    
    @database__index.delete
        
    @database__reverse_index.delete


    
  end
  
  ############
  #  cursor  #
  ############

  def cursor

    #return ::Persistence::Adapter::KyotoCabinet::Cursor.new( @parent_bucket, self, @database__index.cursor )
    raise "Sql does not uses cursors"
  end

  #########################
  #  permits_duplicates?  #
  #########################
  
  def permits_duplicates?

    return @permits_duplicates

  end

  ###################
  #  get_object_id  #
  ###################

  def get_object_id( key )

    serialized_index_key = Marshal::dump( key.to_s )

    global_id = @database__index.where(:key => serialized_index_key ).get(:global_id)
    
    return global_id ? global_id.to_i : nil

  end
  
  #####################
  #  index_object_id  #
  #####################

  def index_object_id( global_id, key )
    serialized_index_key = Marshal::dump( key.to_s )
    
    # we point to object.persistence_id rather than primary key because the object.persistence_id is the object header
    @database__index.insert(:key => serialized_index_key, :global_id => global_id )
    @database__reverse_index.insert( :global_id => global_id, :key => serialized_index_key )

  end

  ################################
  #  delete_keys_for_object_id!  #
  ################################

  def delete_keys_for_object_id!( global_id )

    serialized_key = @database__reverse_index.where(:global_id => global_id ).get(:key)
    @database__reverse_index.where(:global_id => global_id ).delete
    @database__index.where(:key => serialized_key ).delete    

  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ##########################
  #  table_index_database  #
  ##########################

  def table__index_database()


    return (@parent_bucket.name + '_index_' + @name.to_s).to_sym

  end

  ##################################
  #  file__reverse_index_database  #
  ##################################

  def file__reverse_index_database()
    
    return (@parent_bucket.name + '_reverse_index_' + @name.to_s).to_sym

  end

  ######################################
  #  extension__bucket_index_database  #
  ######################################

  def extension__bucket_index_database
    
    return extension__database( :tree )

  end

end
