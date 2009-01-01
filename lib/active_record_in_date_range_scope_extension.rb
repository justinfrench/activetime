# A new named_scope <tt>in_date_range</tt> is added to ActiveRecord::Base so that all AR classes
# will have a suitable scope for the has_many-style associations.  You can also call it directly:
# 
#  start_date = Time.gm(2006)
#  end_date = Time.now
#  Post.in_date_range(start_date, end_date, :created_at)
#  # => returns all posts with a created_at between Jan 2006 and now

module ActiveTimeActiveRecordExtensions
  def self.included(within)
    within.class_eval do
      named_scope :in_date_range, lambda { |start_date, end_date, column_name| { 
        :conditions => ["#{column_name} between ? and ?", start_date.to_s(:db), end_date.to_s(:db)] 
      } }
    end
  end
end

if defined?(ActiveRecord)
  ActiveRecord::Base.class_eval do
    include ActiveTimeActiveRecordExtensions
  end
end

