class Api::SpecialPeriodsController < Api::ApplicationController
  # load_and_authorize_resource

  def find
   @special_periods = []
   @special_periods = SpecialPeriod.where(promotional: true)
   render json: {
      success: @special_periods.any?,
      message: "#{@special_periods.to_a&.size} períodos promocionais encontrados",
      collection: @special_periods.as_json(
        except: [
          :created_at, :updated_at, :value_currency
        ]
      )
    } 
  end  

  def find_geolocation    
    @special_periods  = []
    if params[:latitude] && params[:longitude]
      if params[:radius]
        @special_periods = SpecialPeriod.joins(:accommodation).where(accommodation: near([params[:latitude].to_f, params[:longitude].to_f], params[:radius].to_f, unit: :km))
      else
        @special_periods = SpecialPeriod.joins(:accommodation).where(accommodation: near([params[:latitude].to_f, params[:longitude].to_f]))
      end 
    
    @special_periods = @special_periods.where(promotional: true)      
    end
    render json: {
      success: @special_periods.any?,
      message: "#{@special_periods.to_a&.size} períodos especiais encontrados",
      collection: @special_periods.as_json(
        except: [
          :created_at, :updated_at
        ]
      )
    }

  end  

end  
