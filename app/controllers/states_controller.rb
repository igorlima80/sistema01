class StatesController < Admin::ApplicationController
  load_and_authorize_resource

  # GET /states
  def index
  end

  # GET /states/1
  def show
  end

  # GET /states/new
  def new
  end

  # GET /states/1/edit
  def edit
  end

  # POST /states
  def create
    @state = State.new(state_params)

    if @state.save
      redirect_to @state, notice: 'State was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /states/1
  def update
    if @state.update(state_params)
      redirect_to @state, notice: 'State was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /states/1
  def destroy
    @state.destroy
    redirect_to states_url, notice: 'State was successfully destroyed.'
  end

  private
    # Only allow a trusted parameter "white list" through.
    def state_params
      params.require(:state).permit(:name)
    end
end
