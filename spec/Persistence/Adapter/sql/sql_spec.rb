
require_relative '../../../../lib/persistence/adapter/sql.rb'

describe ::Persistence::Adapter::Sql do


  
  $__persistence__spec__adapter__ = ::Persistence::Adapter::Sql.new( :adapter=>:postgres, :database=> :test )

  after do
    [:table1, :table2].each{|x| Sequel::Model.db.from(x).truncate}
  end
  
  # adapter spec
  require_relative File.join( ::Persistence::Adapter::Abstract.spec_location, 'Adapter_spec.rb' )

end