
require_relative '../../../../lib/persistence/adapter/sequel.rb'

describe ::Persistence::Adapter::Sequel do


  
  $__persistence__spec__adapter__ = ::Persistence::Adapter::Sequel.new( :adapter => 'tinytds', :user => 'some_users', :host => 'some_host')

  
  # adapter spec
  require_relative File.join( ::Persistence::Adapter::Abstract.spec_location, 'Adapter_spec.rb' )

end