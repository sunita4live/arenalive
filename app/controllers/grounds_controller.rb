  class GroundsController < ApplicationController
    before_action :authenticate_user! , except: [:search]
    load_resource only: [:show, :create ,:update, :destroy, :edit]
    PER_PAGE = 5
    def search
    	category = params[:category]
    	city = params[:city]
    	area = params[:area]
    	date = params[:date].to_date
    	@grounds = Kaminari.paginate_array(Ground.search(category, city, area, date)).page(params[:page] || 1).per(PER_PAGE)

    end

    def index
      @grounds = current_user.grounds if current_user.present? #&& current_user.has_role? "ground_owner"

    end

    def show
      @booking = Booking.new
    end
    
    def ground_details
      @ground = Ground.find(params[:id])
    end

    # GET /grounds/new
    def new
      @ground = Ground.new
      #@ground_attachment = @ground.ground_attachments.build
    end

    # GET /grounds/1/edit
    def edit
      @added_dates = @ground.booking_dates.map{|e| e.date_of_booking}
      @closing_times = ["12:00 AM","01:00 AM", "02:00 AM", "03:00 AM", "04:00 AM", "05:00 AM", "06:00 AM", "07:00 AM", "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM", "05:00 PM", "06:00 PM", "07:00 PM", "08:00 PM", "09:00 PM", "10:00 PM", "11:00 PM"]
    end

    # POST /grounds
    # POST /grounds.json
    def create
      @ground = Ground.new(ground_params)
      @ground.user = current_user if current_user.has_role? :ground_owner


      respond_to do |format|
        if @ground.save
          @ground.set_date_and_time(params[:ground][:add_booking_dates])
          format.html { redirect_to @ground, notice: 'ground was successfully added.' }
          format.json { render :show, status: :created, location: @ground }
        else
          format.html { render :new }
          format.json { render json: @ground.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /grounds/1
    # PATCH/PUT /grounds/1.json
    def update
      respond_to do |format|
        if @ground.update(ground_params)
          @ground.update_date_and_time(params[:ground][:add_booking_dates], params[:ground][:add_closing_dates], params[:ground][:closing_times])
          @ground.update_special_closing_time(params[:ground][:special_closing_date], params[:ground][:special_closing_times])
          #@ground.update_date_and_time(ground_params[:start_date], ground_params[:end_date])
          format.html { redirect_to @ground, notice: 'ground was successfully updated.' }
          format.json { render :show, status: :ok, location: @ground }
        else
          format.html { render :edit }
          format.json { render json: @ground.errors.messages, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /grounds/1
    # DELETE /grounds/1.json
    def destroy
      if @ground.destroy
        respond_to do |format|
          format.html { redirect_to grounds_url, notice: 'ground was successfully destroyed.' }
          format.json { head :no_content }
        end
      end
    end

    
    def booking_initialize
      unless params[:slot_ids].split("{:value=>\"\"}").reject(&:empty?).blank?
        @price = params[:book_a].to_i
        ids =  params[:slot_ids].split(',').reject(&:empty?)
        @booked_event = []
        ids.each do |i|
          slot = BookingTime.find_by(id: i.to_i)
          @booked_event << slot
        end
        @Total_price = @booked_event.map{|t| t.booking_date.weekend_day? ? t.booking_date.ground.end_price : t.booking_date.ground.day_price}.inject(:+)
        @booked_event
      else
        @ground = Ground.find(params[:ground])
        redirect_to ground_details_ground_path(@ground), notice: "please select slots"
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_ground
        @ground = ground.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ground_params
        params.require(:ground).permit(:start_date, :end_date, :name, :city, :area, :pincode, :address, :status, :category, :weekend_price, :weekday_price, :court, :phone, :attention_message , booking_dates_attributes: [:id, :date_of_booking, :status, :ground_id, :_destroy, booking_times_attributes: [:id, :time_of_booking, :status, :booking_date_id, :timeslot_id, :_destroy]], ground_attachments_attributes: [:id, :ground_id, :photo, :_destroy])
      end

  end
