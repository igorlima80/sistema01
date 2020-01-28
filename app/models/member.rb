class Member < ApplicationRecord
  include TranslateEnum

  enum status: {
    visited: 0,    
    unvisited: 1   
  }
  translate_enum :status
  
  belongs_to :leader
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

def birthdate_br
  
end  


def member_json
  self.to_json(
    methods: [:translate_status, :birthdate_br],
    except: [:created_at, :updated_at, :leader_id],
    include: [ 
        leader:{
          methods: [:name],
          except:[ :created_at, :updated_at, :mother_name, :father_name, :user_id, :rg, :cpf, :latitude, :longitude]
           
        },
        address: {
          include:[
              city:{
                methods: [:name_with_state],
                only: [:id]
              }
            ],
          except:[:city_id, :addressable_type, :addressable_id, :created_at, :updated_at] 
        }
  ])
end





end


