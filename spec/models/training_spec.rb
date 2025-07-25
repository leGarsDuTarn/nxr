require 'rails_helper'

RSpec.describe Training, type: :model do

  # Attention creer un user car Training belongs to User avec let (scope etendue)
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
    training = Training.new(
      name: "entrainement libre",
      date: Date.new(2026, 3, 10),
      hour: Time.parse("10:00"),
      user: user # on lui assigne un user
    )
    expect(training).to be_valid
  end

  it "ne valide pas le test si le name n'est pas renseigné" do
    training = Training.new(
      date: Date.new(2026, 3, 10),
      hour: Time.parse("10:00"),
      user: user
    )
    training.validate
    expect(training.errors[:name]).to include("Vous devez renseigner un nom")
  end

  it "ne valide pas le test si la date n'est pas renseigné" do
    training = Training.new(
      name: "entrainement libre",
      hour: Time.parse("10:00"),
      user: user
    )
    training.validate
    expect(training.errors[:date]).to include("Vous devez renseigner une date")
  end

  it "ne valide pas le test si l'heure n'est pas renseigné" do
    training = Training.new(
      name: "entrainement libre",
      date: Date.new(2026, 3, 10),
      user: user
    )
    training.validate
    expect(training.errors[:hour]).to include("Vous devez renseigner une heure")
  end
end
