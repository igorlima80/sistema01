class CitiesController < Admin::ApplicationController
  load_and_authorize_resource

  # GET /cities
  def index
    @q = City.ransack(params[:q])
    @cities = @q.result(distinct: true).page(params[:page]).per 10
  end

  # GET /cities/1
  def show
  end

  # GET /cities/new
  def new
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  def create
    @city = City.new(city_params)

    if @city.save
      redirect_to @city, notice: 'City was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /cities/1
  def update
    if @city.update(city_params)
      redirect_to @city, notice: 'City was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /cities/1
  def destroy
    @city.destroy
    redirect_to cities_url, notice: 'City was successfully destroyed.'
  end

  private
    # Only allow a trusted parameter "white list" through.
    def city_params
      params.require(:city).permit(:description, :state_id, :name, :ibge)
    end
end
