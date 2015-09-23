class BookingsController < ApplicationController
  before_action :authenticate_user! #, except: [:search]
  load_resource only: [:show, :create ,:update, :destroy, :edit]
  PER_PAGE = 5


  def index
    @bookings = Booking.all #current_user.bookings if current_user.present? #&& current_user.has_role? "ground_owner"

  end

  def show
  end

  # GET /grounds/new
  def new
    @booking = Booking.new
  end

  # GET /grounds/1/edit
  def edit
      
  end

  # POST /grounds
  # POST /grounds.json
  def create
    @booking = booking.new(booking_params)
    @booking.user = current_user if current_user.has_role? :member
    

    respond_to do |format|
      if @booking.save

        # params[:ground_attachments]['photo'].each do |p|
        #   @booking_attachment = @booking.ground_attachments.create!(:photo => p)
        # end
        format.html { redirect_to @booking, notice: 'Booking created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grounds/1
  # PATCH/PUT /grounds/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors.messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grounds/1
  # DELETE /grounds/1.json
  def destroy
    if @booking.destroy
      respond_to do |format|
        format.html { redirect_to grounds_url, notice: 'Booking was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:user_id, :cancel, :slot_ids[])
    end

end
