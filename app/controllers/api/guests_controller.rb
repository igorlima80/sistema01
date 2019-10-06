class Api::GuestsController < Api::ApplicationController
  # load_and_authorize_resource

  def show
    @guest = {}
    @guest = Guest.find_by(id: params[:id])
    if @guest
      render json: @guest.guest_json
    else
      render json: nil
    end
  end
 
  # POST /api/guests
  def create    
    @guest = Guest.new(guest_params)
    
    if @guest.user
      list = Guest.joins(:user).where(users: { email: @guest.user.email })
      if list.any?
        render json: list[0].guest_json
      else
        if @guest.user.password.nil? || @guest.user.password.empty?
         @guest.user.assign_generated_password
        end 
                
        if @guest.save
          render json: @guest.guest_json, status: :created, location: @guest
        else
          render json:{
            message: @guest.errors.full_messages,
            status: :unprocessable_entity
          } 
        end
      end
    else
      render json:{
        message: @guest.errors.full_messages,
        status: :unprocessable_entity
      } 
    end
  end

  # POST /api/guests/1
  def update
    @guest = Guest.find params[:id]
    if @guest.update(guest_params)
      render json: @guest.guest_json
    else
      render json:{
        message: @guest.errors.full_messages,
        status: :unprocessable_entity
      }
    end
  end

  def find_by_email
    list = Guest.joins(:user).where(users: { email: params[:email] })    
    if list.any?
      @guest = list.first
      if @guest
        render json: @guest.guest_json
      else
        render json: nil
      end 
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end  
  
  def reserves
    @guest = Guest.find_by(id: params[:id])
    if @guest
      render json: @guest.reserves.order(created_at: :desc).as_json(
        methods: [:translate_status],
        except: [:total_value_currency, :created_at, :updated_at],
        include: [
          accommodation: {
            methods: [:common_images_urls, :fachada_images_urls, :plans],
            except: [:id, :value_per_night, :maximum_adult, :maximum_child, :available, :value_per_night_cents,
                  :value_per_night_currency, :rating, :property_id, :type_trip_id, :type_accommodation_id, 
                  :created_at, :updated_at, :fake_latitude, :fake_longitude],
            include: [
              address: {
                except: [:id, :city_id, :addressable_type, :addressable_id, :created_at, :updated_at]
              } 
            ]  
          },
          services:{
          only: [:id, :name, :description, :value_cents, :include_in_daily]
          },
          fees: {
            only: [:id, :value_cents],
            methods: [:fee_name]
          }, 
          rating:{
            except: [:id]
          }
        ]
      )
    end
  end

  private
    def guest_params
      params.fetch(:guest).permit(:image,
        social_data: {},
        user_attributes: [:id, :email, :name, :provider, :cpf],
        address_attributes: [
          :id, :description, :zipcode, :street, :number, :complement, :district, :city_id
        ]
      )
    end
end
