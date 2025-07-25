require 'rails_helper'

RSpec.describe Registration, type: :model do
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

  let(:event) do
    Event.create!(
      name: "testname",
      description: "testdesc",
      date: Date.today,
      hour: Time.now,
      user: user
    )
  end

  context "Quand l'utilisateur est inscrit à un événement" do
    it "Le test est valide avec un user lié à un événement" do
      registration = Registration.new(user: user, registerable: event)
      expect(registration).to be_valid
    end
  end

  context "Quand aucun utilisateur n'est lié à un événement" do
    it "Le test n'est pas valide si aucun utilisateur n'est relié à un événement" do
      registration = Registration.new(registerable: event)
      expect(registration).not_to be_valid
    end
  end

  context "Quand un utilisateur est inscrit deux fois au même événement " do
    it "Le test n'est pas valide" do
      Registration.create(user: user, registerable: event)
      double_registration = Registration.new(user: user, registerable: event)
      expect(double_registration).not_to be_valid
    end
  end

  context "Quand la date de l'activité est passé" do
    it "L'utilisateur ne peux plus s'inscrire à l'événement" do
      event = Event.create!(
        name: "testname",
        description: "testdesc",
        date: Date.yesterday,
        hour: Time.now,
        user: user
      )
      registration = Registration.new(user: user, registerable: event)
      expect(registration).not_to be_valid
      expect(registration.errors[:registerable]).to include("cet événement n'est plus ouvert aux inscriptions")
    end
  end

  # Fausse class créée uniquement pour le test
  class Cooking < ApplicationRecord
    self.table_name = 'events' # réutilise une table existante pour éviter les erreurs
    belongs_to :user
  end
  context "Quand l'inscription ne concerne pas un événement de type Race, Training ou Event" do
    it "Le test n'est pas valide avec un autre type d'événement" do

      cooking = Cooking.create!(
        name: "test",
        description: "testdesc",
        date: Date.today,
        hour: Time.now,
        user: user
      )
      registration = Registration.new(user: user, registerable: cooking)
      expect(registration).not_to be_valid
      expect(registration.errors[:registerable_type]).to include("Cooking n’est pas un type d’inscription valide")
    end
  end
end
