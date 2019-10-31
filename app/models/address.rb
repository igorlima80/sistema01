class Address < ApplicationRecord
  belongs_to :city, optional: true
  belongs_to :addressable, polymorphic: true

  validates :zipcode, presence: true
  validates :street, presence: true
  validates :district, presence: true

  def full_address
    "#{street}#{', ' unless number.blank?}#{number}#{'. CEP ' unless zipcode.blank?}#{zipcode}#{'. ' unless complement.blank?}#{complement}#{'. Bairro: ' unless district.blank?}#{district}#{'. ' if city}#{city.name_with_state if city}"
  end

  def full(join_char = '. ')
    [street, number, "#{'CEP ' unless zipcode.blank?}#{zipcode}", complement, district, "#{city.name_with_state if city}"].select{|x| x != "" && !x.nil? }.join(join_char)
  end

  def geo_address
     [street, number, city&.name, city&.state&.name, 'Brasil'].compact.join(', ')
    #[city&.name, city&.state&.name, 'Brasil'].compact.join(', ')
  end
end
