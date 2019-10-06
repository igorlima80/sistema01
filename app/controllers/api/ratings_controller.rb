class Api::RatingsController < Api::ApplicationController
  # load_and_authorize_resource

   def create 
    
    @reserve = Reserve.find(params[:id])

    if  @reserve.rating.nil?
      @reserve.rating = Rating.new(rating_params)   
    else 
      @reserve.rating.comment = params[:comment]
      @reserve.rating.score = params[:score]  

    end         

    @reserve.rating.moment = Time.zone.now 
    @reserve.reserve_status = :evaluated  
    
    if @reserve.save
      
      render json: @reserve.as_json(        
            methods: [:translate_status],
            only: [:id, :reserve_status],
              include: [
                rating:{
                  only:[:moment, :comment, :score]
                } 
              ]         
      ), status: :created
    else
     render json: nil, status: :unprocessable_entity
    end
  end

   private
    def rating_params
      params.permit(:comment, :score )
    end      
end
 