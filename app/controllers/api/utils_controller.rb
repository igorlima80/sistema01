class Api::UtilsController < Api::ApplicationController
    
    def zipcode
      render json: ViaCep::Address.new(params['zipcode'])
    end
  end
  