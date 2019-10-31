class Api::MembersController < Api::ApplicationController
    #load_and_authorize_resource

def find_unvisited
   
  @members  = Member.where(leader_id: params[:id])
         
    if params[:latitude] && params[:longitude]      
      if params[:radius]
        @members = Member.near([params[:latitude].to_f, params[:longitude].to_f], params[:radius].to_f, unit: :km)
      else
        @members = Member.near([params[:latitude].to_f, params[:longitude].to_f])
      end          
    end

    if @members.any?
      @members = @members.where(status: "unvisited")
    end
    render json: {
      success: @members.any?,
      message: "#{@members.to_a&.size} membros encontrados",
      collection: @members.as_json(
        methods: [:translate_status],
        except: [:created_at, :updated_at], 
        include: [
          address: {
            except: [:id, :city_id, :addressable_type, :addressable_id, :created_at, :updated_at]
          }        
        ]
      )
    }
  end

  def show
    @member = {}
    @member = Member.find_by(id: params[:id])
    if @member
      render json:  @member.as_json(
        methods: [:translate_status],
        except: [:created_at, :updated_at], 
        include: [
          address: {
            except: [:id, :city_id, :addressable_type, :addressable_id, :created_at, :updated_at]
          },
          visits:{
            only: [:date_visit, :observation, :number_of_voters]
          }        
        ]
      )
    else
      render json:  {
        message: @member.errors.full_messages,
        member: @member.as_json,
        status: :unprocessable_entity
      }
    end
  end

  def find
   
    @members  = Member.where(leader_id: params[:id])
         
    if params[:latitude] && params[:longitude]      
      if params[:radius]
        @members = Member.near([params[:latitude].to_f, params[:longitude].to_f], params[:radius].to_f, unit: :km)
      else
        @members = Member.near([params[:latitude].to_f, params[:longitude].to_f])
      end          
    end
    
    render json: {
      success: @members.any?,
      message: "#{@members.to_a&.size} membros encontrados",
      collection: @members.as_json(
        methods: [:translate_status],
        except: [:created_at, :updated_at], 
        include: [
          address: {
            except: [:id, :city_id, :addressable_type, :addressable_id, :created_at, :updated_at]
          }    
        ]
      )
    }
  end

  def create   
    @member = Member.new(member_params)  
    @member.status = "unvisited"
    if @member.save
      render json: @member.as_json(
        methods: [:translate_status],
        except: [:created_at, :updated_at], 
        include: [
          address: {
            except: [:id, :city_id, :addressable_type, :addressable_id, :created_at, :updated_at]
          }        
        ]
      ), status: :created
    else
      render json:  {
        message: @member.errors.full_messages,
        member: @member.as_json,
        status: :unprocessable_entity
      }
    end
  end

     # POST /api/members/1
     def update
      @member = Member.find params[:id]
      if @member.update(member_params)
        render json: @member.member_json
      else
        render json:{
          message: @member.errors.full_messages,
          status: :unprocessable_entity
        }
      end
    end


  private
  def member_params
    params.fetch(:member).permit(:name, :cpf, :birthdate, :leader_id,     
      address_attributes: [
        :id, :_destroy, :description, :zipcode, :street, :number, :complement, :district, :city_id
      ],
      visits_attributes: [
          :id, :_destroy, :date_visit, :observation, :number_of_voters
        ]
    )
  end

  

end