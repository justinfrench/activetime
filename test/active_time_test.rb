require File.dirname(__FILE__) + '/test_helper'

class ActiveTimeTest < ActiveSupport::TestCase
  
  setup do
    setup_db
  end
  
  teardown do
    teardown_db
  end
  
  def year
    2008
  end
  
  def month
    11
  end
  
  def day
    14
  end
  
  def starting
    Time.gm(2007, 11, 14)
  end
  
  def ending
    Time.gm(2008, 11, 14)
  end
  
  context "ActiveRecord::Base subclasses" do
        
    should "respond to the in_date_range named scope" do
      assert Post.respond_to?(:in_date_range)
    end
    
  end
  
  context "ActiveTime" do
    
    context "when initialized with no args" do
      
      should "raise ArgumentError" do
        assert_raise ArgumentError do
          ActiveTime.new()
        end
      end
    
    end
    
    context "when initialized with only one time object as an arg instead of two" do
      
      should "raise ArgumentError" do
        assert_raise ArgumentError do
          ActiveTime.new(Time.now)
        end
      end
    
    end
    
    context "when initialized with any more than three integer args" do
      
      should "raise ArgumentError" do
        assert_raise ArgumentError do
          ActiveTime.new(1, 2, 3, 4)
        end
      end
      
    end
    
    context "when initialized with a year arg" do
      
      setup do
        @target = Time.gm(year)
        @object = ActiveTime.new(year)
      end
      
      should "have a :year #range" do
        assert_equal :year, @object.range
      end
      
      should "have a #starting year equal to the target year" do
        assert_equal year, @object.starting.year
      end
      
      should "have an #ending year equal to the target year" do
        assert_equal year, @object.ending.year
      end
      
      should "have a description" do
        assert_equal "in 2008", @object.description
      end
      
    end
    
    context "when initialized with year and month args" do
      
      setup do
        @target = Time.gm(year, month)
        @object = ActiveTime.new(year, month)
      end
      
      should "have a :month #range" do
        assert_equal :month, @object.range
      end
      
      should "have a #starting year and month equal to the target year and month" do
        assert_equal year,  @object.starting.year
        assert_equal month, @object.starting.month
      end
      
      should "have an #ending year and month equal to the target year and month" do
        assert_equal year,  @object.ending.year
        assert_equal month, @object.ending.month
      end
      
      should "have a description" do
        assert_equal "in November 2008", @object.description
      end
      
    end
    
    context "when initialized with year, month and day args" do
      
      setup do
        @starting = Time.gm(year, month, day)
        @object = ActiveTime.new(year, month, day)
      end
      
      should "have a :day #range" do
        assert_equal :day, @object.range
      end
      
      should "have a #starting year, month and day equal to the target year, month and day" do
        assert_equal year,  @object.starting.year
        assert_equal month, @object.starting.month
        assert_equal day,   @object.starting.day
      end
      
      should "have an #ending year, month and day equal to the target year, month and day" do
        assert_equal year,  @object.ending.year
        assert_equal month, @object.ending.month
        assert_equal day,   @object.ending.day
      end
      
      should "have a description" do
        assert_equal "on November 14, 2008", @object.description
      end
      
    end
    
    context "when initialized with two time objects as args" do
      
      setup do
        @object = ActiveTime.new(starting, ending)
      end
      
      should "have a :custom #range" do
        assert_equal :custom, @object.range
      end
      
      should "have a #starting equal to the target starting time" do
        assert_equal starting, @object.starting
      end
      
      should "have an #ending equal to the target ending time" do
        assert_equal ending, @object.ending
      end
      
      should "have a description" do
        assert_equal "between November 14 2007 00:00:00 and November 14 2007 00:00:00", @object.description
      end
      
    end
    
    context "when initialized correctly" do
      
      setup do
        @object = ActiveTime.new(year)
      end
      
      should "respond to #range and return a symbol" do
        assert @object.respond_to?(:range)
        assert @object.range.is_a?(Symbol)
      end
      
      should "respond to #time and return a Time object in UTC" do
        assert @object.respond_to?(:time)
        assert @object.time.is_a?(Time)
        assert @object.time.utc?
      end
      
      should "respond to #starting and return a Time object in UTC" do
        assert @object.respond_to?(:starting)
        assert @object.starting.is_a?(Time)
        assert @object.starting.utc?
      end
      
      should "respond to #ending and return a Time object in UTC" do
        assert @object.respond_to?(:ending)
        assert @object.ending.is_a?(Time)
        assert @object.ending.utc?
      end
      
      should "return an equal value for #time and #starting (aliases)" do
        assert_equal @object.starting, @object.time
      end
      
      should "respond to methods named after collections of ActiveRecord objects" do
        assert @object.respond_to?(:posts)
        assert @object.respond_to?(:activity_events)
        assert @object.respond_to?(:users)
        assert @object.respond_to?(:summaries)
      end
      
      should "infer a class name from the missing method name" do
        assert_equal "Post",          ActiveTime.send(:class_name_for_method_name, "posts")
        assert_equal "ActivityEvent", ActiveTime.send(:class_name_for_method_name, "activity_events")
        assert_equal "User",          ActiveTime.send(:class_name_for_method_name, "users")
        assert_equal "Summary",       ActiveTime.send(:class_name_for_method_name, "summaries")
      end
      
      should "not raise NoMethodError if the collection's class responds to in_date_range" do
        assert Post.respond_to?(:in_date_range)
        assert_nothing_raised do
          ActiveTime.new(2008).posts
        end
      end
      
      should "raise NoMethodError if the collection's class doesn't respond to in_date_range" do
        assert !NonActiveRecordThing.respond_to?(:in_date_range)
        assert_raise NoMethodError do
          ActiveTime.new(2008).non_active_record_things
        end
      end
      
      should "raise NameError if the collection's class doesn't exist" do
        assert_raise NameError do
          ActiveTime.new(2008).foos
        end
        assert_raise NameError do
          ActiveTime.new(2008).bahs
        end
      end
      
    end
                
  end
    
end
