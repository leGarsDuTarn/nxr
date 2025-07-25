require 'rails_helper'

RSpec.describe "Admin::Races", type: :request do
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

  let(:race) do
    Race.create!(
      name: "testname",
      description: "testdes",
      date: Date.today,
      hour: Time.now,
      user: admin
    )
  end

  before do
    # Appel race avant chaque test, évite un DRY inutile
    race
    # Simule une session admin avec Devise
    sign_in admin
  end

  describe "GET/admin/races" do # Méthode index
    context "Quand un admin est connecté" do
      it " retourne un status 200, affiche le mon des courses et valide le test" do
        get admin_races_path(format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(race.name)
      end
    end
  end

  describe "GET/admin/races/:id" do # Méthode show
    context "Quand un admin est connecté et affiche les détails d'une course" do
      it "retourne un status 200, affiche le nom et la description d'une course et valide le test" do
        get admin_race_path(race)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(race.name)
        expect(response.body).to include(race.description)
      end
    end
  end

  describe "GET/admin/races/new" do # Méthode new
    context "Quand un admin est connecté et crée un nouvelle course" do
      it "retourne un status 200 et valide le test" do
        get new_admin_race_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("course")
      end
    end
  end

  describe "POST /admin/races" do # Méthode create
    context "Quand un admin connecté poste une nouvelle course" do
      it "crée une nouvelle course avec une image liée, redirige l'user (302) et valide le test" do
        # Permet de charger une image depuis le fichier de test fixtures
        file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg")
        race_params = {
          name: "testrace",
          description: "testdescription",
          date: Date.today,
          hour: Time.now,
          image: file
        }
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          post admin_races_path, params: { race: race_params }
        }.to change(Race, :count).by(1) # Ici permet de vérifier que la course est bien créé en DB
        expect(Race.last.image).to be_attached # Ici verifie que l'image est bien attaché
        expect(response).to have_http_status(:redirect) # Vérifie que l'user est bien redirigé (302)
        expect(Race.last.name).to eq("testrace") # Vérifie que 'test' est bien le nom attribué à la course postée
      end
    end
  end

  describe "GET/admin/races/:id/edit" do # Méthode edit
    context "Quand un admin connecté modifie une course existante" do
      it "modifie une course existante, retourne un status 200 et valide le test" do
        get edit_admin_race_path(race)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/modifier/i) # case insensitive = Modifier ou modifier
      end
    end
  end

  describe "PATCH/admin/races/:id" do # Méthode update
    context "Quand un admin poste une course modifiée" do
      it "poste une course modifiée avec image, redirige l'user (302) et valide le test" do
        # Permet de charger une iamge depuis le fichier de test fixtures
        file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg")

        updated_params = {
          name: "testupdate",
          description: "testuptodate",
          date: Date.today,
          hour: Time.now,
          image: file
        }
        patch admin_race_path(race), params: { race: updated_params }
        race.reload # Recharge les données depuis la DB
        expect(response).to have_http_status(:redirect)
        expect(race.image).to be_attached
        expect(race.name).to eq("testupdate")
      end
    end
  end

  describe "DELETE/admin/races/:id" do # Méthode destroy
    context "Quand l'admin delete une course" do
      it "delete une course, redirige l'user (302) et valide le test" do
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete admin_race_path(race)
        }.to change(Race, :count).by(-1) # Ici permet de vérifier que la course est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end
end
