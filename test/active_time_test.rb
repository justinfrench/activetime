require File.dirname(__FILE__) + '/test_helper'

class ActiveTimeTest < ActiveSupport::TestCase
  
  setup do
    setup_db
  end
  
  teardown do
    teardown_db
  end
  
  context "ActiveRecord::Base subclasses" do
        
    should "respond to the in_date_range named scope" do
      assert Post.respond_to?(:in_date_range)
    end
    
  end
  
  context "ActiveTime" do
    
    context "when incorrectly initialized" do
    
      should "raise ArgumentError when no args are provided" do
        assert_raise ArgumentError do
          ActiveTime.new()
        end
      end
      
      should "raise ArgumentError when one Time arg is provided" do
        assert_raise ArgumentError do
          ActiveTime.new(Time.now)
        end
      end
      
      should "not raise ArgumentError when two Time args are provided" do
        assert_nothing_raised ArgumentError do
          ActiveTime.new(Time.now, 1.minute.from_now)
        end
      end
      
    end
            
  end
    
end
