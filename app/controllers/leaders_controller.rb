class LeadersController  < Admin::ApplicationController
  load_and_authorize_resource

  # GET /leaders
  def index
   @leaders = Leader.all
  end

  # GET /leaders/1
  def show
  end

  # GET /leaders/new
  def new
    @leader.build_user
    @leader.build_address
  end

  # GET /leaders/1/edit
  def edit    
  end

  # POST /leaders
  def create
    @leader = Leader.new(leader_params)

    if @leader.save
      redirect_to @leader, notice: 'Leader was successfully created.' 
    else
      render :new
    end
  end

  # PATCH/PUT /leaders/1
  def update
    if @leader.update(leader_params)
      redirect_to @leader, notice: 'Leader was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /leaders/1
  def destroy
    @leader.destroy
    redirect_to leaders_url, notice: 'Leader was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leader
      @leader = Leader.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def leader_params
      params.require(:leader).permit(:mother_name, :father_name, :rg,
        user_attributes: [
            :id, :_destroy, :name, :email, :password, :image, :cpf
          ],
          address_attributes: [
            :id, :_destroy, :description, :zipcode, :street, :number, :complement,
            :district, :city_id
          ]      
      )
    end
end
