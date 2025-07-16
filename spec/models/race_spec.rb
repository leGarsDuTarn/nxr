require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:user) do
    User.create!(
      user_name: "testuserrace",
      first_name: "Benji",
      last_name: "User",
      email: "ben@gmail.com",
      phone_number: "0678456123",
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
