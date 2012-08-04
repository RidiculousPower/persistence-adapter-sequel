
require_relative '../../../../lib/persistence/adapter/sql.rb'

describe ::Persistence::Adapter::Sql do

  $__persistence__spec__adapter__ = ::Persistence::Adapter::Sql.new( :adapter=>:postgres, :database=>"Sivli" )
  
  # adapter spec
  require_relative File.join( ::Persistence::Adapter::Abstract.spec_location, 'Adapter_spec.rb' )

end