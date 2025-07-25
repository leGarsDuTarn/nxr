require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:user) do
    User.create!(
      user_name: "testuser_name",
      role: "member",
      first_name: "test_fname",
      last_name: "test_lname",
      email: "test@mail.com",
      phone_number: "0600000000",
      birth_date: Date.new(1992, 6, 5),
      address: "testadress",
      post_code: "73000",
      country: "France",
      license_code: "NCO",
      license_number: "123456",
      club_member: true,
      club_name: "testclubname",
      bike_brand: "KTM",
      cylinder_capacity: 50,
      stroke_type: "2T",
      plate_number: "AN-123-CD",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
  end

  it "valide les tests avec l'ensemble des champs correctement renseigné" do
    race = Race.new(
      name: "Qualification pour la coupe",
      date: Date.new(2025, 5, 16),
      hour: Time.parse("09:00"),
      user: user
    )
    expect(race).to be_valid
  end

  it "ne valide pas les tests si name est absent" do
    race = Race.new(
      date: Date.new(2025, 5, 16),
      hour: Time.parse("09:00"),
      user: user
    )
    race.validate
    expect(race.errors[:name]).to include("Vous devez renseigner un nom")
  end

  it "ne valide pas les tests si date est absent" do
    race = Race.new(
      name: "Course finale",
      hour: Time.parse("09:00"),
      user: user
    )
    race.validate
    expect(race.errors[:date]).to include("Vous devez renseigner une date")
  end

  it "ne valide pas les test si hour est absent" do
    race = Race.new(
      name: "Course test",
      date: Date.new(2025, 5, 10),
      user: user
    )
    race.validate
    expect(race.errors[:hour]).to include("Vous devez renseigner une heure")
  end
end
