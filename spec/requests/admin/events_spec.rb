require 'rails_helper'

RSpec.describe "Admin::Events", type: :request do
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

  before do
    # Simule une session admin avec Devise
    sign_in admin
  end

  describe "GET/admin/events" do
    context "Quand un admin est connecté" do
      it "retourne un status 200 et valide le test" do
        get admin_events_path(format: :html)
        expect(response).to have_http_status(:ok)
      end
    end
  end
  describe "Get/admin/events/:id" do
    context "Quand un admin est connecté et affiche les détails d'un événement" do
      it "retourne un status 200 et valide le test" do
        event = Event.create!(
          name: "Repas été",
          description: "testdescription",
          date: Date.today,
          hour: Time.now,
          user: admin
        )
        # Simule requête HTTP GET et test la route Get/admin/events/:id
        get admin_event_path(event)
        # Vérifie que la réponse HTTP est en status 200
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Repas été")
        expect(response.body).to include("testdescription")
      end
    end
  end
end
