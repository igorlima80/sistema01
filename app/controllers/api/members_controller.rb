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
      collection: @members.where(status: "unvisited").as_json
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
      collection: @members.as_json
    }
  end


  

end