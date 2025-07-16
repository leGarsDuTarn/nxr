require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) do
    User.create!(
      user_name: "testuserforevent",
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
  end

  subject do
    described_class.new(
      name: "repas du club",
      date: Date.new(2025, 6, 3),
      hour: Time.parse("12:00"),
      user: user
    )
  end

  context "Quand tous les champs sont correctement remplis" do
    it "Le test est valid" do
      expect(subject).to be_valid
    end
  end

  context "Quand le nom est absent" do
    before { subject.name = nil }

    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:name]).to include("Vous devez renseigner un nom")
    end
  end

  context "Quand la date est absente" do
    before { subject.date = nil }

    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:date]).to include("Vous devez renseigner une date")
    end
  end

  context "Quand l'heure est absente" do
    before { subject.hour = nil }

    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:hour]).to include("Vous devez renseigner une heure")
    end
  end
end
