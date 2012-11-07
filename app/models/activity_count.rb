class ActivityCount < ActiveRecord::Base
  # Set attributes as accessible for mass-assignment
  attr_accessible :count, :time, :user_id
end
