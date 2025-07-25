require 'rails_helper'

RSpec.describe "Admin::Trainings", type: :request do
  let(:admin) do
    User.create!(
      user_name: "testuser_name",
      role: "admin",
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
    # Appel training avant chaque test, évite un DRY inutile
    training
    # Simule une session admin avec Devise
    sign_in admin
  end

  describe "GET/admin/trainings" do # Méthode index
    context "Quand un admin est connecté" do
      it " retourne un status 200, affiche le mon des entraînements et valide le test" do
        get admin_trainings_path(format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(training.name)
      end
    end
  end

  describe "GET/admin/trainings/:id" do # Méthode show
    context "Quand un admin est connecté et affiche les détails d'un entraînement" do
      it "retourne un status 200, affiche le nom et la description d'un entraînement et valide le test" do
        get admin_training_path(training)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(training.name)
        expect(response.body).to include(training.description)
      end
    end
  end

  describe "GET/admin/trainings/new" do # Méthode new
    context "Quand un admin est connecté et crée un nouvel entraînement" do
      it "retourne un status 200 et valide le test" do
        get new_admin_training_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("entraînement")
      end
    end
  end

  describe "POST /admin/trainings" do # Méthode create
    context "Quand un admin connecté poste un nouvel entraînement" do
      it "crée un nouvel entraînement avec une image liée, redirige l'user (302) et valide le test" do
        # Permet de charger une iamge depuis le fichier de test fixtures
        file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg")
        training_params = {
          name: "testtraining",
          description: "testdescription",
          date: Date.today,
          hour: Time.now,
          image: file
        }
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          post admin_trainings_path, params: { training: training_params }
        }.to change(Training, :count).by(1) # Ici permet de vérifier que l'entraînement est bien créé en DB
        expect(Training.last.image).to be_attached # Ici verifie que l'image est bien attaché
        expect(response).to have_http_status(:redirect) # Vérifie que l'user est bien redirigé (302)
        expect(Training.last.name).to eq("testtraining") # Vérifie que 'test' est bien le nom attribué à l'entraînement posté
      end
    end
  end

  describe "GET/admin/trainings/:id/edit" do # Méthode edit
    context "Quand un admin connecté modifie un entraînement existant" do
      it "modifie un entraînement existant, retourne un status 200 et valide le test" do
        get edit_admin_training_path(training)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/modifier/i) # case insensitive = Modifier ou modifier
      end
    end
  end

  describe "PATCH/admin/trainings/:id" do # Méthode update
    context "Quand un admin poste un entraînement modifié" do
      it "poste un entraînement modifié avec image, redirige l'user (302) et valide le test" do
        # Permet de charger une iamge depuis le fichier de test fixtures
        file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg")

        updated_params = {
          name: "testupdate",
          description: "testuptodate",
          date: Date.today,
          hour: Time.now,
          image: file
        }
        patch admin_training_path(training), params: { training: updated_params }
        training.reload # Recharge les données depuis la DB
        expect(response).to have_http_status(:redirect)
        expect(training.image).to be_attached
        expect(training.name).to eq("testupdate")
      end
    end
  end

  describe "DELETE/admin/trainings/:id" do # Méthode destroy
    context "Quand l'admin delete un entraînement" do
      it "delete un entraînement, redirige l'user (302) et valide le test" do
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete admin_training_path(training)
        }.to change(Training, :count).by(-1) # Ici permet de vérifier que l'entraînement est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end
end
