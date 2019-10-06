# class CieloClient
#   include Singleton
#
#   def initialize
#     configs = YAML.load_file("#{Rails.root}/config/sticapi.yml")[Rails.env]
#     Cielo::API30.merchant(configs[:merchant_id], configs[:merchant_keys])
#   end
# end
# configs = YAML.load_file("#{Rails.root}/config/cielo.yml")[Rails.env]
# @merchant = Cielo::API30.merchant(configs['merchant_id'], configs['merchant_key'])
