class Member < ApplicationRecord
  include TranslateEnum

  enum status: {
    visited: 0,    
    unvisited: 1   
  }
  translate_enum :status
  
  belongs_to :leader, optional: true
  has_one :address, dependent: :destroy, as: :addressable
  has_many :visits, dependent: :destroy

    
  accepts_nested_attributes_for :address, allow_destroy: true
  accepts_nested_attributes_for :visits, allow_destroy: true

  geocoded_by :geo_address
  after_validation :geocode



def geo_address
  address&.geo_address
end

def leader_name
 self.leader.name
end

def translate_status
  self.human_enum_name(:status, self.status)
end

def member_json
  self.to_json(
    except: [:created_at, :updated_at],
    include: [     
        address: {            
          include: [
            city: {
              except: [:id, :state_id, :created_at, :updated_at],
              include: [
                state: {
                  except: [:id, :ibge, :created_at, :updated_at]
                }
              ]
            }
          ]
        }
  ])
end



def member_params
  params.require(:member).permit(:name, :leader_id, :cpf, :status,
   
      address_attributes: [
        :id, :_destroy, :description, :zipcode, :street, :number, :complement,
        :district, :city_id
      ]      
  )
end



end


