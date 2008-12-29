class ActiveTime
  
  attr_accessor :starting, :ending
  alias_method :time, :starting
  
  # Creates an object representing a period of time with a starting and ending 
  # time.  There's a few ways to create the ActiveTime object:
  #
  #   # A whole year (eg Tue Jan 01 00:00:00 UTC 2008 - Wed Dec 31 23:59:59 UTC 2008):
  #   ActiveTime.new(2008)
  #   
  #   # A whole month (eg Sat Nov 01 00:00:00 UTC 2008 - Sun Nov 30 23:59:59 UTC 2008):
  #   ActiveTime.new(2008, 11)
  #   
  #   # A whole day (eg Wed Nov 12 00:00:00 UTC 2008 - Wed Nov 12 23:59:59 UTC 2008)
  #   ActiveTime.new(2008, 11, 12)
  #   
  #   # Any two Time objects:
  #   ActiveTime.new(Time.now.beginning_of_day, Time.now.end_of_day)
  #
  # TODO: Allow an hour, minute and even second.
  def initialize(*args)
    case args.first
    when Fixnum, String
      @year, @month, @day, @hour, @min, @sec = *args
      @starting = Time.gm(year, month, day)
      @ending = @starting.send("end_of_#{range}")
    when Time
      raise(ArgumentError, "both a starting and ending time must be supplied") unless (args[1] && args[1].is_a?(Time))
      @starting, @ending = *args
    else
      raise ArgumentError, "arguments must either be (starting_time, ending_time) or (year,[month,[day],[hour],[min],[sec]])"
    end
  end
  
  # A symbol representing the range:
  #
  # * :custom if no year was supplied (Time objects were supplied instead)
  # * :year if no month is supplied
  # * :month if no day is supplied
  # * :day if year, month and day are supplied
  # * :custom if a specific start and end Time were supplied  
  def range
    return :custom if @year.nil?
    return :year if @month.nil?
    return :month if @day.nil?
    return :day if @hour.nil?
    return :hour
  end
  memoize :range
      
  # Allows association calls similar to has_many to be called on the ActiveTime object, with the
  # missing method name used to infer the class name (posts => Post).  We then call in_date_range 
  # (a named scope which is expected) on the class to get all objects within the date range.
  #
  # Example method, given a Post class:
  #
  #   def posts
  #     Post.in_date_range(starting, ending, :created_at)
  #   end
  #
  # TODO: memoize the results, to avoid multiple queries for the same method call.
  def method_missing(method_name, *args)
    if method_name.to_s =~ /[a-z_]+s$/
      args[0] ||= :created_at
      begin
        klass_name = method_name.to_s.singularize.classify
        klass = klass_name.constantize
        return klass.in_date_range(starting, ending, args[0]) # Post.in_date_range(start_time, end_time, :created_at)
      rescue NoMethodError
        raise NoMethodError, "expected #{klass_name} to have a named scoped of 'in_date_range'"
      rescue NameError
        raise NameError, "called #{method_name} on an ActiveTime object, but could not find a #{klass_name} class"
      end
    else
      super
    end
  end
  
  # Provides a human friendly string description of the date or time range being used.  Examples:
  #
  #   ActiveTime.new(2008)                      # => "in 2008"
  #   ActiveTime.new(2008, 11)                  # => "in November 2008"
  #   ActiveTime.new(2008, 11, 18)              # => "on November 18 2008"
  #   ActiveTime.new(2008, 11, 18, 14)          # => "from 14:00 to 15:00 on November 18 2008"
  #   ActiveTime.new(2008, 11, 18, 14, 18)      # => "from 14:18 to 14:19 on November 18 2008"
  #   ActiveTime.new(2008, 11, 18, 14, 18, 22)  # => "from 14:18:22 to 14:19:23 on November 18 2008"
  #
  # TODO: could be a whole lot DRYer and configurable
  def description
    case range
    when :year
      "in #{starting.year}" # in 2008
    when :month
      "in #{starting.strftime("%B %Y")}" # in November 2008
    when :day
      "on #{starting.strftime("%B %d, %Y")}" # on November 18, 2008
    when :hour, :min, :sec
      "between #{starting.strftime("%H:%M")} and #{ending.strftime("%H:%M")} on #{starting.strftime("%B %d, %Y")}" # between 22:00 and 23:00 on November 18, 2008
    when :sec
      "between #{starting.strftime("%H:%M:%S")} and #{ending.strftime("%H:%M:%S")} on #{starting.strftime("%B %d, %Y")}" # between 22:18 and 23:19 on November 18, 2008
    else
      "between #{starting.strftime("%B %d %Y %H:%M:%S")} and #{starting.strftime("%B %d %Y %H:%M:%S")}" # from 14:18:22 to 14:19:23 on November 18 2008
    end
  end
  
end