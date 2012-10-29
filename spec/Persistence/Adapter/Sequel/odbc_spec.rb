
require_relative '../../../../lib/persistence/adapter/sequel.rb'

describe ::Persistence::Adapter::Sequel do


  
  $__persistence__spec__adapter__ = ::Persistence::Adapter::Sequel.new( :adapter => 'odbc', :driver => 'mydb', :user => "root", :database => 'testing')

  
  # adapter spec
  require_relative File.join( ::Persistence::Adapter::Abstract.spec_location, 'Adapter_spec.rb' )

end