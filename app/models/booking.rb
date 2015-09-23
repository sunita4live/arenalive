class Booking < ActiveRecord::Base
  belongs_to :user
  has_many :Booking_times
end
