class Api::MembersController < Api::ApplicationController
    #load_and_authorize_resource

def find_unvisited
    @members  = []
         
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
      collection: @members.where(status: "unvisited").as_json(
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

  def find
    @members  = []
         
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
      collection: @member.as_json(
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
        reserve: @member.as_json,
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