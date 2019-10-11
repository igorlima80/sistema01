class Member < ApplicationRecord
  belongs_to :leader 
  has_one :address, dependent: :destroy, as: :addressable

  accepts_nested_attributes_for :address, allow_destroy: true
  
  geocoded_by :geo_address
  after_validation :geocode

  def geo_address
    address&.geo_address
  end
 

end
