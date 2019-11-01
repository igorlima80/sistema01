class Leader < ApplicationRecord
    
    has_one :address, dependent: :destroy, as: :addressable
    has_many :members
    has_one_attached :image, dependent: :destroy

    after_create :assign_role 
    has_one :user, as: :userable
       
    accepts_nested_attributes_for :user, allow_destroy: true
    accepts_nested_attributes_for :address, allow_destroy: true

    validates :cpf, presence: true, uniqueness: true

    geocoded_by :geo_address
    after_validation :geocode

  def assign_role
    self.user.remove_role :basic
    self.user.add_role :guest
  end

  def name
    self.user.name
  end

  def user_name
    self.user.name
  end

  def geo_address
    address&.geo_address
  end

  def image_attached?
    self.image.attached?
  end
 

  def leader_json
    self.to_json(
      except: [:created_at, :updated_at, :user_id ],
      include: [ 
          address: {
            except:[:id, :addressable_type, :addressable_id, :created_at, :updated_at] 
          }
    ])
  end
end

