class Api::VisitsController < Api::ApplicationController
    #load_and_authorize_resource


  def create   
    @visit = Visit.new(visit_params)  
    if @visit.save
      @visit.member.status = "visited"
      @visit.member.save
      render json: @visit.as_json(
        except: [:created_at, :updated_at], 
      ), status: :created
    else
      render json:  {
        message: @visit.errors.full_messages,
        visit: @visit.as_json,
        status: :unprocessable_entity
      }
    end
  end


  private
  def visit_params
    params.fetch(:visit).permit( :date_visit, :observation, :number_of_voters, :member_id)
  end

  

end