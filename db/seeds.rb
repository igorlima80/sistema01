require 'net/http'

u = User.create email: 'admin@admin.com', password: '12345678'
u.add_role :admin


Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end
