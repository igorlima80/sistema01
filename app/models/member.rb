class Member < ApplicationRecord
  enum status: {
    visited: 0,    
    unvisited: 1   
  }
  
  belongs_to :leader, dependent: :destroy, optional: true
  has_one :address, dependent: :destroy, as: :addressable

    
  accepts_nested_attributes_for :address, allow_destroy: true

  geocoded_by :geo_address
  after_validation :geocode



def geo_address
  address&.geo_address
end

def translate_status
  self.human_enum_name(:status, self.status)
end

end


