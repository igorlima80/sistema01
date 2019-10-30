class Leader < ApplicationRecord
    
    has_one :address, dependent: :destroy, as: :addressable
    has_many :members
    has_one_attached :image, dependent: :destroy

    after_create :assign_role 
    has_one :user, as: :userable
       
    accepts_nested_attributes_for :user, allow_destroy: true
    accepts_nested_attributes_for :address, allow_destroy: true

    validates :cpf, cpf: true, uniqueness: true

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
      except: [:email, :name, :city_id, :user_id, :created_at, :updated_at],
      include: [:image_attached?,
        user: {
          except: [:generated_password, :uid, :userable_id, :userable_type, :created_at, :updated_at]
      },
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
end

