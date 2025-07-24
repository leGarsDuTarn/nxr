require 'rails_helper'

RSpec.describe "Admin::Registrations", type: :request do
  let(:admin) do
    User.create!(
      user_name: "leGarsDuTarn",
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,",
      role: "admin"
    )
  end

  let(:race) do
    Race.create!(
      name: "testname",
      description: "testdes",
      date: Date.today,
      hour: Time.now,
      user: admin
    )
  end

  let(:event) do
    Event.create!(
      name: "testname",
      description: "testdescription",
      date: Date.today,
      hour: Time.now,
      user: admin
    )
  end

  let(:training) do
    Training.create!(
      name: "testname",
      description: "testdes",
      date: Date.today,
      hour: Time.now,
      user: admin
    )
  end

  before do
    # Simule une session admin avec Devise
    sign_in admin
    # Appel race avant chaque test, évite un DRY inutile
    race
    # Appel event avant chaque test, évite un DRY inutile
    event
    # Appel training avant chaque test, évite un DRY inutile
    training
  end

  describe 

  describe "GET/admin/events/:events_id/registrations" do # Méthode Index
    context "Quand un admin accéde à une inscription d'un événement" do
      it " retourne un status 200, affiche les inscriptions et valide le test" do
        get admin_event_registrations_path(event, format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(event.name)
      end
    end
  end
end
