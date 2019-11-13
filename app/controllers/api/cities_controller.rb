class Api::CitiesController < Api::ApplicationController
  # load_and_authorize_resource

  def find
    params[:q] = {} unless params[:q]
    params[:q][:s] = 'name asc' unless params[:q][:s]
    params[:q][:name_cont] = params[:description] if params[:description]
    @q = City.ransack(params[:q])
    @cities = @q.result(distinct: true).page(params[:page])
    render json: {
      success: @cities.any?,
      message: "#{@cities.size} cidades encontradas",
      collection: @cities.as_json
    }
  end

  def find_states
    @states = State.all  
    render  json: @states.order(name: :asc).as_json( {
      success: @states.any?,
      message: "#{@states.size} estados encontrados",
      collection: @states
    })
  end

  def find_by_state
    @cities = City.where(state_id: params[:state_id])   
    render  json: @cities.order(name: :asc).as_json( {
      success: @cities.any?,
      message: "#{@cities.size} cidades encontradas",
      collection: @cities
    })
  end

  def find_by_ibge
    @city = City.where(ibge: params[:ibge]).first

    if @city
      render json: @city.as_json(
        include:[
                state:{
                  only: [:id, :name]
                }
              ]
      )
    else
      render json:{
        status: :not_found
      }
    end

  end

end
