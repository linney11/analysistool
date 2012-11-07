class User < ActiveRecord::Base

  has_many :activity_counts
  has_many :gps_samples
  # Set attributes as accessible for mass-assignment
  attr_accessible :name, :edad
end
