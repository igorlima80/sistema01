class Api::LeadersController < Api::ApplicationController
  #load_and_authorize_resource

  def login
    @leader = {}
    @leader = Leader.where(cpf: params[:cpf]).first

    if @leader
      render json: @leader.leader_json
    else
      render json:{
        status: :not_found
      }
    end

  end  
  
  def show
    @leader = {}
    @leader = Leader.find_by(id: params[:id])
    if @leader
      render json: @leader.leader_json
    else
      render json: nil
    end
  end

   # POST /api/leaders/1
   def update
    @leader = Leader.find params[:id]
    if @leader.update(leader_params)
      render json: @leader.leader_json
    else
      render json:{
        message: @leader.errors.full_messages,
        status: :unprocessable_entity
      }
    end
  end
 
 
  
  def members
    @leader = Leader.find_by(id: params[:id])
    if @leader
      render json: @leader.members.order(created_at: :desc).as_json(
        methods: [:translate_status],
        except: [:created_at, :updated_at],
        include: [          
              address: {
                except: [:id, :city_id, :addressable_type, :addressable_id, :created_at, :updated_at]
              } 
            ]         
      )
    end
  end

  private
    def leader_params
      params.fetch(:leader).permit(:mother_name, :father_name, :rg,
        user_attributes: [:id, :_destroy, :email, :name, :cpf],
        address_attributes: [
          :id, :_destroy, :description, :zipcode, :street, :number, :complement, :district, :city_id
        ]
      )
    end
end

