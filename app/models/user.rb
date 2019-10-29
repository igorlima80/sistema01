class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  rolify

  before_validation :assign_uid

  after_create :assign_role
  after_create :assign_generated_password

  

  belongs_to :userable, polymorphic: true, optional: true

  validates :email, presence: true, uniqueness: true
  has_one_attached :image, dependent: :destroy
  validates :cpf, cpf: true, if: Proc.new {|u| ["Leader", ""].include? userable_type }

  def address
    self.userable.address
  end

  

  def assign_role
    self.add_role(:basic) if self.roles.blank?
  end

  def assign_uid
    self.uid = self.email if self.uid.blank?
  end

  def assign_generated_password
    if self.encrypted_password.blank?
      self.generated_password = SecureRandom.hex
      self.password = self.generated_password
      self.save
    end
  end

  def image_urls
    self.image.map do |i|
      Rails.application.routes.url_helpers.rails_blob_path(i, only_path: true)
    end
  end
end 
