class MembersController  < Admin::ApplicationController
  load_and_authorize_resource

  # GET /member
  def index
   @members = Member.all
  end

  # GET /members/1
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
    @member.build_address
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  def create
    @member = Member.new(member_params)
    @member.status = "unvisited"
    if @member.save
      redirect_to @member, notice: 'Member was successfully created.' 
    else
      render :new
    end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
      redirect_to @member, notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /member/1
  def destroy
    @member.destroy
    redirect_to members_url, notice: 'Member was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def member_params
      params.require(:member).permit(:name, :leader_id, :birthdate, :cpf, :status,       
          address_attributes: [
            :id, :_destroy, :description, :zipcode, :street, :number, :complement,
            :district, :city_id
          ],
          visits_attributes: [
            :id, :_destroy, :date_visit, :observation, :number_of_voters
          ]      
      )
    end
end



