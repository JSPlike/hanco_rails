# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


admin_user = User.create( name: "관리자", email: 'admin@hanco.com', password: ENV['admin_password'], confirmed_at: Time.now )
admin_user.add_role :admin