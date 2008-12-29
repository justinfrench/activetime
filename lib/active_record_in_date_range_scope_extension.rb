# A new named_scope <tt>in_date_range</tt> is added to ActiveRecord::Base so that all AR classes
# will have a suitable scope for the has_many-style associations.  You can also call it directly:
# 
#  start_date = Time.gm(2006)
#  end_date = Time.gm(2007)
#  Post.in_date_range(start_date, end_date)
#  # => returns all posts with a created_at between start_date and end_date
class ActiveRecord::Base
  named_scope :in_date_range, lambda { |start_date, end_date, column_name| { 
    :conditions => ["#{column_name} between ? and ?", start_date.to_s(:db), end_date.to_s(:db)] 
  } }
end