require File.dirname(__FILE__) + '/test_helper'

class ActiveTimeTest < ActiveSupport::TestCase
  
  setup do
    setup_db
  end
  
  teardown do
    teardown_db
  end
    
end
