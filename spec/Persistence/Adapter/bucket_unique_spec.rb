
require 'persistence'
	  	
require 'persistence/adapter/sequel'

describe ::Persistence::Adapter do
  
  before :all do

    @adapter = ::Persistence::Adapter::Sequel.new( :adapter => 'postgres', :database=> 'test', :host => 'localhost' )

    ::Persistence.enable_port( :mock, @adapter )

    class ::Persistence::Adapter::MockObject
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::CascadingConfiguration::Setting
      attr_non_atomic_accessor :attribute
    end

    @object = ::Persistence::Adapter::MockObject.new
    @object.attribute = :some_value

    @bucket = @adapter.persistence_bucket( @object.persistence_bucket.name )    

  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end
  
  ##########################
  #  attribute life cycle  #
  ##########################

  it "can put a attribute, then get that attribure, then delete that attribute" do
  
    primary_key = @bucket.primary_key_for_attribute_name( @object, :attribute )
    
    # put_attribute!
    @bucket.put_attribute!( @object, primary_key, 'attribute!' )

    # get_attribute
    @bucket.get_attribute( @object, primary_key ).should == 'attribute!'

    # delete_attribute!
    @bucket.delete_attribute!( @object, primary_key )
    @bucket.get_attribute( @object, primary_key ).should == nil
  
  end

  #########################
  #  attribute overwrite  #
  #########################
  
  it "can overwrite a given attribute" do 
  	
  	primary_key = @bucket.primary_key_for_attribute_name( @object, :attribute )
  	
  	# put_attribute!
    @bucket.put_attribute!( @object, primary_key, 'some_attribute' )
    
    # put_attribute! as an overwrite
    @bucket.put_attribute!( @object, primary_key, 'some_other_attribute' )
    
    # get_attribute
    @bucket.get_attribute( @object, primary_key ).should == 'some_other_attribute'
  	
  end

end
