class BookingDate < ActiveRecord::Base
	belongs_to :ground
	has_many :booking_times, :dependent => :destroy
	accepts_nested_attributes_for :booking_times, reject_if: :all_blank, allow_destroy: true

	validates_uniqueness_of :date_of_booking


	def weekend_day?
    	day =  self.date_of_booking.strftime("%A").downcase 
    	weekends = ["saturday", "sunday"]
    	weekends.include?(day)
  	end	

end
