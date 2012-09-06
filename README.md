# Sequel Persistence Adapter #

* Rubygem page to be added when alfa development is complete!

# Summary #


Adapter to use <a href="http://sequel.rubyforge.org">Sequel</a> as storage port for <a href="https://rubygems.org/gems/persistence">Persistence</a> (<a href="https://github.com/RidiculousPower/persistence">on GitHub</a>).

# Description #

Implements necessary methods to run Persistence on top of Sequel.

# Install #

Currently only available on github:

* Currently working on build solution.

# Usage #

The Sequel adapter is a Persistence wrapper for the Sequel gem. Using it requires specifying your method of connection to your database as such:

```ruby
sequel_adapter = ::Persistence::Adapter::Sequel.new( :adapter => :postgres, :database => :your_database_name )
port_name = :sequel_port

Persistence.enable_port( port_name, sequel_adapter )
```

The details connecting to the database will very. Note that `::Persistence::Adapter::Sequel.new(args & blocks)` works just like `Sequel.connect(args & blocks)` from the Sequel gem. For connection options see <a href="http://sequel.rubyforge.org/rdoc/files/doc/opening_databases_rdoc.html">Sequel.connect</a>.

At this point the list of tested sub adapters are:

* Amalgalite

In theory all Sequel adapters should work within Persistence but as of yet not all have been tested.

To use Amalgalite:

* Install the amalgalite gem

* Add your adapter
```ruby sequel_adapter = ::Persistence::Adapter::Sequel.new( :adapter => 'amalgalite', :database => 'your_database_file') ```

To use MySQL:

* Install the mysql gem

* Add your adapter
```ruby sequel_adapter =  ::Persistence::Adapter::Sequel.new( :adapter => 'mysql', :database => 'your_database', :user => 'your_user' )```

To use MySQL2:

* Install the mysql2 gem

* Add your adapter
```ruby sequel_adapter = ::Persistence::Adapter::Sequel.new( :adapter => 'mysql2', :database => 'your_database', :user => 'your_user')```

To use PostgreSQl:

* Install the pg gem

* Add your adapter
```ruby sequel_adapter = ::Persistence::Adapter::Sequel.new( :adapter => 'postgres', :database => 'your_database', :user => 'your_user' )```

To use SQLite:

* Install the sqlite3 gem (Older gems not tested)

* Add your adapter
```ruby sequel_adapter = ::Persistence::Adapter::Sequel.new( :adapter => 'sqlite', :database => 'your_database_file')```

To use Swift:

* Install a Swift gem (e.g. swift-db-sqlite3)

* Add your adapter
```ruby sequel_adapter = ::Persistence::Adapter::Sequel.new( :adapter => 'swift', :db_type => 'your_database_type', :database => 'your_database')```

# License #

  (The MIT License)

  Copyright (c) 2012, Asher, Ridiculous Power

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  'Software'), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
