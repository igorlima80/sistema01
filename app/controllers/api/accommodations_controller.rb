class Api::AccommodationsController < Api::ApplicationController
  # load_and_authorize_resource

  def find
    @accommodations  = []
    start_date = Time.zone.today
    end_date = Time.zone.today
     
    if params[:latitude] && params[:longitude]      
      if params[:radius]
        @accommodations = Accommodation.near([params[:latitude].to_f, params[:longitude].to_f], params[:radius].to_f, unit: :km)
      else
        @accommodations = Accommodation.near([params[:latitude].to_f, params[:longitude].to_f])
      end
      @accommodations = @accommodations.where(available: true)
      @accommodations = @accommodations.where(accommodation_type_id: params[:accommodation_type_id]) if params[:accommodation_type_id]
      if params[:checkin_date] && params[:checkout_date]
        @accommodations = @accommodations.available_between(params[:checkin_date], params[:checkout_date])
        start_date = params[:checkin_date]
        end_date = params[:checkout_date]
      end 
    end
    
    render json: {
      success: @accommodations.any?,
      message: "#{@accommodations.to_a&.size} acomodações encontradas",
      collection: @accommodations.as_json(start_date: start_date, end_date: end_date)
    }
  end

  def show
    @accommodation = Accommodation.find_by(id: params[:id])
    start_date = Time.zone.today
    end_date = Time.zone.today
    if params[:checkin_date] && params[:checkout_date]
      start_date = params[:checkin_date]
      end_date = params[:checkout_date]
    end
    render json: @accommodation.as_json(start_date: start_date, end_date: end_date)
  end

  def events
    @accommodation = Accommodation.find_by(id: params[:id])
    render json: @accommodation.events.where(
      '(?, ?) overlaps (start_date, final_date)', Date.parse(params[:start]) - 1.day, Date.parse(params[:end]) + 1.day)
    # render json: @accommodation.events.where(
    #   '(start_date >= ? and final_date <= ?) or
    #    (start_date < ? and final_date >= ? and final_date <= ?) or
    #    (start_date >= ? and start_date <= ? and final_date > ?)',
    #   params[:start], params[:end],
    #   params[:start], params[:start], params[:end],
    #   params[:start], params[:end], params[:end])
  end
end
