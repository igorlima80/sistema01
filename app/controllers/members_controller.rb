class MembersController  < Admin::ApplicationController
  load_and_authorize_resource

  # GET /member
  def index   
   @q = Member.ransack(params[:q])
   @members = @q.result.page(params[:page]).per 10
  end


  # GET /members/1  
  def show
  end

  def birthdates
    @q = Member.ransack(params[:q])
    @mes = Date.today.month

    if params[:date]
      @mes = params[:date][:month]
    end  

    @birthdays_of_month = Member.where('extract(month from birthdate) = ?', @mes).order('birthdate DESC')
   
   
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
      params.require(:member).permit(:name, :leader_id, :birthdate, :cpf, :status, :phone, :cell_phone, :date_month,
          
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



