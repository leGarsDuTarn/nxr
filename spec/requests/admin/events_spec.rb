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

  describe "GET/admin/events" do # Métode index
    context "Quand un admin est connecté" do
      it "retourne un status 200, affiche le mon de l'events et valide le test" do
        event = Event.create!(
          name: "testname",
          description: "testdes",
          date: Date.today,
          hour: Time.now,
          user: admin
        )
        # Requête GET avec forcage pour format HTML attendu par le controller évite une erreur 406
        get admin_events_path(format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(event.name)
      end
    end
  end
  describe "Get/admin/events/:id" do # Méthode show
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

  describe "GET/admin/events/new" do # Méthode new
    context "Quand un admin est connecté et crée un nouvel event" do
      it "retourne un status 200 et valide le test" do
        get new_admin_event_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("événement")
      end
    end
  end

  describe "POST /admin/events" do # Méthode create
    context "Quand un admin connecté poste un nouveau formulaire" do
      it "crée un nouvel événement avec une image liée, redirige l'user (302) et valide le test" do
        # Permet de charger une iamge depuis le fichier de test fixtures
        file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg")
        event_params = {
          name: "test",
          description: "testdescription",
          date: Date.new(2025, 6, 3),
          hour: Time.now,
          image: file
        }
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          post admin_events_path, params: { event: event_params }
        }.to change(Event, :count).by(1) # Ici permet de vérifier que l'événement est bien créé en DB
        expect(Event.last.image).to be_attached # Ici verifie que l'image est bien attaché
        expect(response).to have_http_status(:redirect) # Vérifie que l'user est bien redirigé (302)
        expect(Event.last.name).to eq("test") # Vérifie que 'test' est bien le nom attribué à l'event posté
      end
    end
  end

  describe "GET/admin/events/:id/edit" do # Méthode edit
    context "Quand un admin connecté modifie un événement existant" do
      it "modifie un événement existant, retourne un status 200 et valide le test" do
        event = Event.create!(
          name: "testedit",
          description: "testdedit",
          date: Date.today,
          hour: Time.now,
          user: admin
        )
        get edit_admin_event_path(event)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/modifier/i) # case insensitive = Modifier ou modifier
      end
    end
  end

  describe "PATCH/admin/events/:id" do # Méthode update
    context " Quand un admin poste un événement modifié" do
      it " poste un événement modifié avec image, redirige l'user (302) et valide le test" do
        event = Event.create!(
          name: "oldname",
          description: "olddes",
          date: Date.new(2025, 6, 3),
          hour: Time.now,
          user: admin
        )
        # Permet de charger une iamge depuis le fichier de test fixtures
        file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg")

        updated_params = {
          name: "testupdate",
          description: "testuptodate",
          date: Date.new(2025, 6, 3),
          hour: Time.now,
          image: file
        }
        patch admin_event_path(event), params: { event: updated_params }
        event.reload # Recharge les données depuis la DB
        expect(response).to have_http_status(:redirect)
        expect(event.image).to be_attached
        expect(event.name).to eq("testupdate")
      end
    end
  end

  describe "DELETE/admin/events/:id" do # Méthode destroy
    context "Quand l'admin delete un événement" do
      it "delete un événement, redirige l'user (302) et valide le test" do
        event = Event.create!(
          name: "testdelete",
          description: "delete",
          date: Date.new(2025, 6, 3),
          hour: Time.now,
          user: admin
        )
        expect {
          delete admin_event_path(event)
        }.to change(Event, :count).by(-1) # Ici permet de vérifier que l'événement est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end
end
