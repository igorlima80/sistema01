class Api::ReservesController < Api::ApplicationController
  # load_and_authorize_resource

  def show
    @reserve = {}
    @reserve = Reserve.find_by(id: params[:id])
    if @reserve
      render json: @reserve
    else
      render json: nil
    end
  end

  def create   
    @reserve = Reserve.new(reserve_params)  
    if @reserve.save
      render json: @reserve.as_json(
        methods: [:translate_status],
        except: [:total_value_currency, :created_at, :updated_at], 
        include: [
          credit_card: {
            except: [:id, :security_code, :brand, :expiration_date, 
                      :holder, :card_number, :reserve_id, :payment_cielo_id, :text_capture, :installments, :created_at, :updated_at]
          },
          accommodation:{
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
            only: [:name, :description, :value_cents, :include_in_daily]
          },
          fees: {
            only: [:value_cents],
            methods: [:fee_name]
          }           
        ]
      ), status: :created
    else
      render json:  {
        message: @reserve.errors.full_messages,
        reserve: @reserve.as_json(
        include:[
           credit_card: {
                    except: [:id, :security_code, :brand, :expiration_date, 
                              :holder, :card_number, :reserve_id, :payment_cielo_id, :text_capture, :installments, :created_at, :updated_at]
                  }
          ]
        ), status: :unprocessable_entity
      }
    end
  end
  
  def cancel   
    @reserve = {}
    @reserve = Reserve.find(params[:id])
    @reserve.cancel_date = Time.now

    agora = Time.now
    dias = ( @reserve.checkin_date.day - agora.day )

    if dias > @reserve.setting.days_for_reserve_refund             
      @reserve.reserve_status = 'canceled_with_refund' 
    else
      @reserve.reserve_status = 'canceled_without_refund'
    end     

    if @reserve.save
     
      render json: @reserve.as_json(
        methods: [:translate_status],
        except: [:total_value_currency, :customer_code, :order_code, :payment_code, :created_at, :updated_at]), status: :created
    else
      render json: @reserve.errors, status: :unprocessable_entity
    end
  end

  def find_brand
    url   = 'https://apiquery.cieloecommerce.cielo.com.br/1/cardBin/' + params[:number].to_s
    
    render json: RestClient::Resource.new(url, { headers: headers } ).to_json, status: :created   
  end

  private
    def reserve_params
      params.fetch(:reserve).permit(
        :guest_id, :number_adult, :number_child, :accommodation_id,
        :number_pets, :checkin_date, :checkout_date,
        :user_id, service_ids: [], fee_ids:[],
        credit_card_attributes:[
          :card_hash, :security_code, :brand, :expiration_month, :expiration_year, :holder, :card_number, :installments
        ]
      )
    end  

end
