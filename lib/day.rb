# Day is simply a wrapper around ActiveTime, with a few subtle differences.  Just like ActiveTime, 
# there are two ways to initialize, with a Fixnum for the year, month and day, or with a Time instance.
#
# Initializing with a year, month and day Fixnum behaves exactly the same as it does in ActiveTime:
#
#   Year.new(2008, 11, 14) # same as ActiveTime.new(2008, 11, 14)
#
# Initializing with a Time instance behaves slightly different to ActiveTime.  Our intent is to have
# an object that represents an entire month, so instead of supplying a starting and ending Time, you
# can simply pass in any Time object, and it's year and month will be used to infer the correct 
# starting and ending dates.
# 
# The following all have the same starting time...
#
#   Month.new(Time.gm(2008, 11, 14, 1)).starting    # => Fri Nov 14 00:00:00 UTC 2008
#   Month.new(Time.gm(2008, 11, 14, 3)).starting    # => Fri Nov 14 00:00:00 UTC 2008
#   Month.new(Time.gm(2008, 11, 14, 7)).starting    # => Fri Nov 14 00:00:00 UTC 2008
#   Month.new(2008, 11, 14).starting                # => Fri Nov 14 00:00:00 UTC 2008
#
# ... and the same ending time:
#
#   Month.new(Time.gm(2008, 11, 14, 1)).ending      # => Fri Nov 14 23:59:59 UTC 2008
#   Month.new(Time.gm(2008, 11, 14, 3)).ending      # => Fri Nov 14 23:59:59 UTC 2008
#   Month.new(Time.gm(2008, 11, 14, 7)).ending      # => Fri Nov 14 23:59:59 UTC 2008
#   Month.new(2008, 11, 14).ending                  # => Fri Nov 14 23:59:59 UTC 2008
#
# Because Day is a subclass of ActiveTime, all ActiveTime methods are available (see documentation 
# for more details):
#
#   Day.new(Time.now).range                         # => :day
#   Day.new(Time.now).description                   # => "on January 01, 2009"
#   Day.new(Time.now).posts                         # => a collection of Posts created on this day

class Day < ActiveTime
  
  def initialize(*args)
    if(args.empty?)
      raise ArgumentError, "arguments must either be (a Time object) or (year Fixnum, month Fixnum, day Fixnum)"
    elsif(args.size == 1 && args.first.is_a?(Time))
      args = [args.first.year, args.first.month, args.first.day]
    end
    super
  end
  
end