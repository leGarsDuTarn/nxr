require 'rails_helper'

RSpec.describe "Admin::Trainings", type: :request do
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

  describe "GET/admin/trainings" do # Méthode index
    context "Quand un admin est connecté" do
      it " retourne un status 200, affiche le mon de l'entraînement et valide le test" do
        training = Training.create!(
          name: "testname",
          description: "testdes",
          date: Date.today,
          hour: Time.now,
          user: admin
        )
        get admin_trainings_path(format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(training.name)
      end
    end
  end

  describe "GET/admin/trainings/:id" do # Méthode show
    context "Quand un admin est connecté et affiche les détails d'un entraînement" do
      it "retourne un status 200 et valide le test" do
        training = Training.create!(
          name: "testname",
          description: "testdes",
          date: Date.today,
          hour: Time.now,
          user: admin
        )
      end
    end
  end
end
