class Ground < ActiveRecord::Base
  CATEGORY = ["Tabel Tennis", "BadMinton", "Cricket Nets",  "Snooker", "Tennis"]
  CITY =['Delhi', 'Channei']
  AREA =['Connaught Place', 'Chanakyapuri', 'Delhi Cantonment', 'Vasant Vihar', 'North Delhi', 'Narela' ,'Model Town', 'Narela', 'Alipur', 'North West Delhi', 'Kanjhawala', 'Rohini', 'Kanjhawala', 'Saraswati Vihar', 'West Delhi', 'Rajouri Garden', 'Patel Nagar', 'Punjabi Bagh', 'South West Delhi', 'Dwarka', 'Najafgarh', 'Kapashera', 'South Delhi', 'Saket', 'Hauz Khas', 'Mehrauli', 'South East Delhi', 'Defence Colony', 'Lajpat Nagar', 'Kalkaji', 'Sarita Vihar', 'Central Delhi', 'Daryaganj', 'Karol Bagh', 'Kotwali', 'Civil Lines', 'North East Delhi', 'Seelampur', 'Yamuna Vihar', 'Karawal Nagar', 'Shahdara',  'Seemapuri', 'Vivek Vihar', 'East Delhi', 'Preet Vihar', 'Gandhi Nagar', 'Mayur Vihar']
  WEEKDAY = [["Rs. 100", 100.to_f], ["Rs. 150", 150.to_f], ["Rs. 170", 170.to_f], ["Rs. 200", 200.to_f], ["Rs. 220", 220.to_f], ["Rs. 230", 230.to_f], ["Rs. 240", 240.to_f], ["Rs. 250", 250.to_f], ["Rs. 260", 260.to_f], ["Rs. 270", 270.to_f], ["Rs. 280", 280.to_f], ["Rs. 300", 300.to_f], ["Rs. 320", 320.to_f], ["Rs. 330", 330.to_f], ["Rs. 340", 340.to_f], ["Rs. 350", 350.to_f], ["Rs. 360", 360.to_f], ["Rs. 370", 370.to_f], ["Rs. 380", 380.to_f], ["Rs. 400", 400.to_f]]
  WEEKEND = [["Rs. 100", 100.to_f], ["Rs. 150", 150.to_f], ["Rs. 170", 170.to_f], ["Rs. 200", 200.to_f], ["Rs. 220", 220.to_f], ["Rs. 230", 230.to_f], ["Rs. 240", 240.to_f], ["Rs. 250", 250.to_f], ["Rs. 260", 260.to_f], ["Rs. 270", 270.to_f], ["Rs. 280", 280.to_f], ["Rs. 300", 300.to_f], ["Rs. 320", 320.to_f], ["Rs. 330", 330.to_f], ["Rs. 340", 340.to_f], ["Rs. 350", 350.to_f], ["Rs. 360", 360.to_f], ["Rs. 370", 370.to_f], ["Rs. 380", 380.to_f], ["Rs. 400", 400.to_f]]
  belongs_to :user
  has_many :booking_dates, :dependent => :destroy
  has_many :ground_attachments, :dependent => :destroy

  validates :weekday_price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0, :message => "only allow digits"} 
  validates :weekend_price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0, :message => "only allow digits"} 

  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :area
  #validates_numericality_of :value, :on => :create
  acts_as_commontable
  
  ratyrate_rateable 'visual_effects', 'original_score', 'director', 'custome_design'

  accepts_nested_attributes_for :ground_attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :booking_dates, reject_if: :all_blank, allow_destroy: true

  attr_accessor :add_booking_dates, :add_closing_dates, :closing_times, :special_closing_date, :special_closing_times, :slot_ids
  def self.search(category, city, area, date)
    
    if category.present? || city.present? || area.present? || date.present?
      self.joins(:booking_dates).where('category LIKE ? AND city LIKE ? AND area LIKE ? AND booking_dates.date_of_booking = ?', "%#{category}%", "%#{city}%", "%#{area}%","%#{date}%")
      #self.joins(:booking_dates).where('grounds.category = ? OR city = ? OR area = ? OR booking_dates.date_of_booking = ?', category, city, area, date)
      #self.joins(:booking_dates).where('grounds.category = ? AND city = ? AND area = ? AND booking_dates.date_of_booking = ?', category, city, area, date)
    else
      all
    end
  end

  def set_date_and_time(add_booking_dates)
    ground_id = self.id
    booking_dates = add_booking_dates.split(",").map{|e| e.to_date}
    if booking_dates.present?
      booking_dates.each do |d|
        BookingDate.create(date_of_booking: d, ground_id: self.id, status: true)
      end
      booking_dates1 = self.booking_dates
      timeslots = ["12:00 AM","01:00 AM", "02:00 AM", "03:00 AM", "04:00 AM", "05:00 AM", "06:00 AM", "07:00 AM", "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM", "05:00 PM", "06:00 PM", "07:00 PM", "08:00 PM", "09:00 PM", "10:00 PM", "11:00 PM"]
      
      booking_dates1.each do |d|
        timeslots.each do |t|
          BookingTime.create(slot: t, status: true, booking_date_id: d.id)
        end
      end
    end
  end

  def update_date_and_time(add_booking_dates, add_closing_dates, closing_times)
    ground_id = self.id
    add_booking_dates = add_booking_dates.split(",").map{|e| e.to_date} if add_booking_dates.present?
    add_closing_dates = add_closing_dates.split(",").map{|e| e.to_date} if add_closing_dates.present?
    closing_times = closing_times.reject(&:empty?) if closing_times.present?
    timeslots = ["12:00 AM", "01:00 AM", "02:00 AM", "03:00 AM", "04:00 AM", "05:00 AM", "06:00 AM", "07:00 AM", "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM", "05:00 PM", "06:00 PM", "07:00 PM", "08:00 PM", "09:00 PM", "10:00 PM", "11:00 PM"]
    ground_dates = self.booking_dates
    if add_closing_dates.present?
      add_closing_dates.each do |cd|
        ground_dates.each do |d|
          d.destroy if d.date_of_booking == cd
        end
      end
    end
    if add_booking_dates.present?
      add_booking_dates.each do |bd|
        add_date = BookingDate.create(date_of_booking: bd, ground_id: self.id, status: true)
        timeslots.each do |t|
          BookingTime.create(slot: t, status: true, booking_date_id: add_date.id)
        end
      end
    end

    if closing_times.present?
      closing_times.each do |ct|
        self.booking_dates.each do |date|
          date.booking_times.each do |time|
            time.update(status: false) if time.slot == ct
          end
        end
      end
    end    
  end
  
  def update_special_closing_time(special_closing_date, special_closing_times)
    special_closing_date = special_closing_date.to_date
    special_closing_times = special_closing_times.reject(&:empty?)
    current_booking_dates = self.booking_dates
    select_date = current_booking_dates.where(date_of_booking: special_closing_date).first
    if special_closing_date.present?
      special_closing_times.each do |sc|
        select_date.booking_times.each do |ct|
          ct.destroy if ct.slot == sc && ct.booked == false
        end
      end
    end
  end

  def ground_status
    if self.status == true
      "Available"
    elsif self.status == false
      "Not-available"
    end
  end


  def day_price
    (self.weekday_price * 10)/100
  end

  def end_price
    (self.weekend_price * 10)/100
  end
end
