class EventsController < Admin::ApplicationController
  load_and_authorize_resource

  # GET /events
  def index
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)
    @event.user = current_user

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Evento cadastrado com sucesso.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Evento apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:name, :start_date, :final_date, :value, 
        :eventable_type, :accommodation_id)
    end
end
