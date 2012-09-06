# Sequel Persistence Adapter #

# Summary #


Adapter to use <a href="http://sequel.rubyforge.org">Sequel</a> as storage port for <a href="https://rubygems.org/gems/persistence">Persistence</a> (<a href="https://github.com/RidiculousPower/persistence">on GitHub</a>).

# Description #

Implements necessary methods to run Persistence on top of Kyoto Cabinet.

# Install #

Currently only available on github:

* Currently working on build solution.

# Usage #

The Sequel adapter is a Persistence wrapper for the Sequel gem. Using it requires specifying your method of connection to your database.
At this point, only Postgresql has been tested.

```
sequel_adapter = ::Persistence::Adapter::Sequel.new( :adapter=>:postgres, :database=> :your_database_name )

Persistence.enable_port( :sequel_port, sequel_adapter )
```
Note: `::Persistence::Adapter::Sequel.new(args & blocks)` works just like `Sequel.connect(args & blocks)` from the Sequel gem. For connection options see <a href="http://sequel.rubyforge.org/rdoc/files/doc/opening_databases_rdoc.html">Sequel.connect</a>.

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
