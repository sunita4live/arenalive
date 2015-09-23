	class BookingTime < ActiveRecord::Base
	  SLOT = ["12am", "1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm" ]
	  belongs_to :booking_date
	  belongs_to :booking
	  belongs_to :timeslot
	  #validates_uniqueness_of :time_of_booking

	  def ground_details
	  	self.booking_date.ground
	  end
	end
