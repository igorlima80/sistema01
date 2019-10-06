class Api::SettingsController < Api::ApplicationController
  # load_and_authorize_resource

  def show
    
    @setting = Setting.last
   
    if @setting
      render json: @setting
    else
      render json: nil
    end
  end

    
end
 