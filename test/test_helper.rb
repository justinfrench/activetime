require 'test/unit'
require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'shoulda'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

# AR keeps printing annoying schema statements
$stdout = StringIO.new

def setup_db
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(:version => 1) do
    create_table :posts do |t|
      t.column :title, :string
      t.column :body, :text
    end
  end
end
 
def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Post < ActiveRecord::Base
end
