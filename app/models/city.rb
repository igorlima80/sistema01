class City < ApplicationRecord
  belongs_to :state
  has_many :properties
  has_many :guests
  has_many :addresses

  def self.with_accommodation
    City.where(id: Accommodation.joins(:address).pluck(:city_id))
  end

  def name_with_state
    "#{name} - #{state&.acronym}"
  end

  def as_json(options = {})
    super(
      only: [:id, :name, :latitude, :longitude, :state_id],
      methods: [:name_with_state]
    )
  end
end
