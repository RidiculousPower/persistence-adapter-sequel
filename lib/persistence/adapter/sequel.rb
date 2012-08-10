begin ; require 'development' ; rescue ::LoadError ; end

require 'persistence'

require 'sequel'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

class ::Persistence::Adapter::Sequel
  
  include ::Persistence::Adapter::Sequel::AdapterInterface

end
