# Year is simply a wrapper around ActiveTime, with a few subtle differences.  Just like ActiveTime, 
# there are two ways to initialize, with a Fixnum for the year, or with a Time instance.
#
# Initializing with a year Fixnum behaves exactly the same as it does in ActiveTime:
#
#   Year.new(2008) # same as ActiveTime.new(2008)
#
# Initializing with a Time instance behaves slightly different to ActiveTime.  Our intent is to have
# an object that represents an entire year, so instead of supplying a starting and ending Time, you
# can simply pass in any Time object, and it's year will be used to infer the correct starting and
# ending dates.
# 
# The following all have the same starting time...
#
#   Year.new(Time.gm(2008, 11, 14)).starting  # => Tue Jan 01 00:00:00 UTC 2008
#   Year.new(Time.gm(2008, 1, 15)).starting   # => Tue Jan 01 00:00:00 UTC 2008
#   Year.new(Time.gm(2008, 3, 15)).starting   # => Tue Jan 01 00:00:00 UTC 2008
#   Year.new(2008).starting                   # => Tue Jan 01 00:00:00 UTC 2008
#
# ... and the same ending time:
#
#   Year.new(Time.gm(2008, 11, 14)).ending    # => Wed Dec 31 23:59:59 UTC 2008
#   Year.new(Time.gm(2008, 1, 15)).ending     # => Wed Dec 31 23:59:59 UTC 2008
#   Year.new(Time.gm(2008, 3, 15)).ending     # => Wed Dec 31 23:59:59 UTC 2008
#   Year.new(2008).ending                     # => Wed Dec 31 23:59:59 UTC 2008
#
# Because Day is a subclass of ActiveTime, all ActiveTime methods are available (see documentation 
# for more details):
#
#   Yeaar.new(Time.now).range                 # => :year
#   Yeaar.new(Time.now).description           # => "in January 2009"
#   Yeaar.new(Time.now).posts                 # => a collection of Posts created in this year

class Year < ActiveTime
  
  def initialize(*args)
    if(args.empty?)
      raise ArgumentError, "arguments must either be (a Time object) or (year Fixnum)"
    elsif(args.size == 1 && args.first.is_a?(Time))
      args = [args.first.year]
    end
    super
  end
    
end