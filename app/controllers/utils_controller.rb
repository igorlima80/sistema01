class UtilsController < Admin::ApplicationController
  def zipcode
    render json: ViaCep::Address.new(params['zipcode'])
  end
end
