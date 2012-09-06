
require_relative '../../../../lib/persistence/adapter/sequel.rb'

describe ::Persistence::Adapter::Sequel do


  
  $__persistence__spec__adapter__ = ::Persistence::Adapter::Sequel.new( :adapter=>:postgres, :database=> :test )

#Curently not fuctionall, rollback configure must be done in persistence itself.
  RSpec.configure do |c|
      def execute(*args, &block)
        result = nil
        Sequel::Model.db.transaction(:rollback=>:always){result = super(*args, &block)}
        result
      end
  end
  
  # adapter spec
  #require_relative File.join( ::Persistence::Adapter::Abstract.spec_location, 'Adapter_spec.rb' )

end