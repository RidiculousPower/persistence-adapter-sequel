
require_relative '../../../../lib/persistence/adapter/sequel.rb'

describe ::Persistence::Adapter::Sequel do

	#gem install mysqlplus -- --with-mysql-config=/usr/local/Cellar/mysql/5.1.51/bin/mysql_config
  
  $__persistence__spec__adapter__ = ::Persistence::Adapter::Sequel.new( :adapter => 'mysql', :database => 'testing', :user => 'root' )

  
  # adapter spec
  require_relative File.join( ::Persistence::Adapter::Abstract.spec_location, 'Adapter_spec.rb' )

end