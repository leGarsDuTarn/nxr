# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "🗑️ Nettoyage de la base..."
Registration.destroy_all
Event.destroy_all
Race.destroy_all
Training.destroy_all
User.destroy_all

puts "👤 Création des utilisateurs..."
admin = User.create!(
  user_name: "admin",
  first_name: "Admin",
  last_name: "Super",
  email: "admin@gmail.com",
  password: "Password1!",
  role: "admin",
  address: "1 rue de l'admin",
  post_code: "75000",
  town: "Paris",
  country: "France",
  phone_number: "0612345678",
  birth_date: "1980-01-01",
  license_code: "NCO",
  license_number: "123456",
  club_member: true,
  club_name: "Navès"
)

member1 = User.create!(
  user_name: "john_doe",
  first_name: "John",
  last_name: "Doe",
  email: "john@gmail.com",
  password: "Password1!",
  role: "member",
  address: "10 rue des tests",
  post_code: "69000",
  town: "Lyon",
  country: "France",
  phone_number: "0601020304",
  birth_date: "1990-02-02",
  license_code: "NCP",
  license_number: "654321",
  club_member: false,
  club_name: "Moto Club Lyon"
)

member2 = User.create!(
  user_name: "jane_doe",
  first_name: "Jane",
  last_name: "Doe",
  email: "jane@example.com",
  password: "Password1!",
  role: "member",
  address: "20 avenue de la vitesse",
  post_code: "31000",
  town: "Toulouse",
  country: "France",
  phone_number: "0605060708",
  birth_date: "1992-03-03",
  license_code: "NTR",
  license_number: "789012",
  club_member: true,
  club_name: "Navès"
)

puts "📅 Création des Events..."
event1 = Event.create!(
  name: "Enduro d'hiver",
  description: "Course d'enduro dans les bois",
  date: Date.today + 15,
  hour: Time.now.change(hour: 10, min: 0),
  user: admin
)

event2 = Event.create!(
  name: "Stage Cross Débutants",
  description: "Stage d'initiation au motocross",
  date: Date.today + 30,
  hour: Time.now.change(hour: 9, min: 0),
  user: admin
)

puts "🏁 Création des Races..."
race1 = Race.create!(
  name: "Championnat MX1",
  description: "Course pour pilotes confirmés",
  date: Date.today + 20,
  hour: Time.now.change(hour: 14, min: 0),
  user: admin
)

race2 = Race.create!(
  name: "Mini MX Kids",
  description: "Course pour les enfants",
  date: Date.today + 25,
  hour: Time.now.change(hour: 11, min: 0),
  user: admin
)

puts "✅ SEEDS terminés :"
puts "  - Admin : admin@gmail.com / Password1!"
puts "  - Member1 : john@gmail.com / Password1!"
puts "  - Member2 : jane@gmail.com / Password1!"
