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

  let(:user) do
    User.create!(
      user_name: "testusername",
      role: "member",
      first_name: "testfirst",
      last_name: "testlast",
      email: "test@mail.com",
      phone_number: "0678456123",
      address: "testaddress",
      post_code: "73000",
      town: "testville",
      country: "testcountry",
      password: "Password1,",
      password_confirmation: "Password1,"
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

  describe "GET /admin/events/:event_id/registrations" do # Méthode Index event
    context "Quand un admin accéde aux inscriptions d'une activité de type event" do
      it " retourne un status 200, affiche les inscriptions et valide le test" do
        get admin_event_registrations_path(event, format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(event.name)
      end
    end
  end

  describe "GET /admin/races/:race_id/registrations" do # Méthode Index race
    context "Quand un admin accéde aux inscriptions d'une activité de type race" do
      it " retourne un status 200, affiche les inscriptions et valide le test" do
        get admin_race_registrations_path(race, format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(race.name)
      end
    end
  end

  describe "GET /admin/trainings/:training_id/registrations" do # Méthode Index training
    context "Quand un admin accéde aux inscriptions d'une activité de type training" do
      it " retourne un status 200, affiche les inscriptions et valide le test" do
        get admin_training_registrations_path(training, format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(training.name)
      end
    end
  end

  describe "GET /admin/events/:event_id/registrations/:id" do # Méthode show event
    context "Quand un admin est connecté et affiche les détails des inscriptions à un événement de type event" do
      it "retourne un status 200, affiche les informations des users inscrit" do
        # Crée une inscription qui sera visible pour l'admin
        registration = Registration.create!(user: user, registerable: event)
        get admin_event_registration_path(event, registration)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.last_name)
        expect(response.body).to include(user.first_name)
      end
    end
  end

  describe "GET /admin/races/:race_id/registrations/:id" do # Méthode show race
    context "Quand un admin est connecté et affiche les détails des inscriptions à un événement de type race" do
      it "retourne un status 200, affiche les informations des users inscrit" do
        # Crée une inscription qui sera visible pour l'admin
        registration = Registration.create!(user: user, registerable: race)
        get admin_race_registration_path(race, registration)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.last_name)
        expect(response.body).to include(user.first_name)
      end
    end
  end

  describe "GET /admin/trainings/:training_id/registrations/:id" do # Méthode show training
    context "Quand un admin est connecté et affiche les détails des inscriptions à un événement de type training" do
      it "retourne un status 200, affiche les informations des users inscrit" do
        # Crée une inscription qui sera visible pour l'admin
        registration = Registration.create!(user: user, registerable: training)
        get admin_training_registration_path(training, registration)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.last_name)
        expect(response.body).to include(user.first_name)
      end
    end
  end

  describe "DELETE /admin/events/:event_id/registrations/:id" do # Méthode destroy event
    context "Quand l'admin delete une inscription lié à événement de type event" do
      it "supprime l'inscription, redirige l'user (302), et valide le test" do
        # Crée une inscription qui sera supprimée pour le test
        registration = Registration.create!(user: user, registerable: event)
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete admin_event_registration_path(event, registration)
        }.to change(Registration, :count).by(-1) # Ici permet de vérifier que l'inscription est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end

  describe "DELETE /admin/races/:race_id/registrations/:id" do # Méthode destroy race
    context "Quand l'admin delete une inscription lié à événement de type race" do
      it "supprime l'inscription, redirige l'user (302), et valide le test" do
        # Crée une inscription qui sera supprimée pour le test
        registration = Registration.create!(user: user, registerable: race)
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete admin_race_registration_path(race, registration)
        }.to change(Registration, :count).by(-1) # Ici permet de vérifier que l'inscription est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end

  describe "DELETE /admin/trainings/:training_id/registrations/:id" do # Méthode destroy training
    context "Quand l'admin delete une inscription lié à événement de type training" do
      it "supprime l'inscription, redirige l'user (302), et valide le test" do
        # Crée une inscription qui sera supprimée pour le test
        registration = Registration.create!(user: user, registerable: training)
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete admin_training_registration_path(training, registration)
        }.to change(Registration, :count).by(-1) # Ici permet de vérifier que l'inscription est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end
end
