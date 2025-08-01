require 'rails_helper'

RSpec.describe "Admin::Galleries", type: :request do
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

  let(:uploaded_image) { fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg") }

  let(:gallery) do
    Gallery.create!(
      title: "testtitle",
      date: Date.today,
      user: admin,
      images: [uploaded_image]
    )
  end

  before do
    # Simule une session admin avec Devise
    sign_in admin
    # Appel gallery avant chaque test, évite un DRY inutile
    gallery
  end

  describe "GET/admin/galleries" do # Méthode index
    context "Quand un admin est connecté" do
      it " retourne un status 200, affiche le titre des galeries et valide le test" do
        get admin_galleries_path(format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(gallery.title)
      end
    end
  end

  describe "GET/admin/galleries/:id" do # Méthode show
    context "Quand un admin est connecté et affiche une galerie" do
      it "retourne un status 200, affiche le titre et la date d'une galerie et valide le test" do
        get admin_gallery_path(gallery)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(gallery.title)
        expect(response.body).to include(gallery.date.strftime("%d %B %Y"))
      end
    end
  end

  describe "GET/admin/galleries/new" do # Méthode new
    context "Quand un admin est connecté et crée une nouvelle galerie" do
      it "retourne un status 200 et valide le test" do
        get new_admin_gallery_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("galerie")
      end
    end
  end

  describe "POST /admin/galleries" do # Méthode create
    context "Quand un admin connecté poste une nouvelle galerie" do
      it "crée une nouvelle galerie avec plusieurs images, redirige l'user (302) et valide le test" do
        # Permet de charger deux image depuis le fichier de test fixtures
        files = [
          fixture_file_upload(Rails.root.join("spec/fixtures/files/event.jpg"), "image/jpeg"),
          fixture_file_upload(Rails.root.join("spec/fixtures/files/event.jpg"), "image/jpeg")
        ]

        gallery_params = {
          title: "testgallery",
          date: Date.today,
          images: files
        }
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          post admin_galleries_path, params: { gallery: gallery_params }
        }.to change(Gallery, :count).by(1) # Ici permet de vérifier que la galerie est bien créée en DB
        expect(Gallery.last.images.length).to be > 1 # Ici verifie que la galerie possède plusieurs images attachées
        expect(response).to have_http_status(:redirect) # Vérifie que l'user est bien redirigé (302)
        expect(Gallery.last.title).to eq("testgallery") # Vérifie que 'testgallery' est le titre attribué à la galerie postée
      end
    end
  end

  describe "GET/admin/galleries/:id/edit" do # Méthode edit
    context "Quand un admin connecté modifie une galerie existante" do
      it "modifie une galerie existante, retourne un status 200 et valide le test" do
        get edit_admin_gallery_path(gallery)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/modifier/i) # case insensitive = Modifier ou modifier
      end
    end
  end

  describe "PATCH/admin/galleries/:id" do # Méthode update
    context "Quand un admin poste une galerie modifiée" do
      it "poste une galerie modifiée avec images, redirige l'user (302) et valide le test" do
        # Permet de charger une image depuis le fichier de test fixtures
        file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg")

        updated_params = {
          title: "testupdate",
          date: Date.today,
          images: file
        }
        patch admin_gallery_path(gallery), params: { gallery: updated_params }
        gallery.reload # Recharge les données depuis la DB
        expect(response).to have_http_status(:redirect)
        expect(gallery.images).to be_attached
        expect(gallery.title).to eq("testupdate")
      end
    end
  end

  describe "DELETE/admin/galleries/:id" do # Méthode destroy
    context "Quand l'admin delete une galerie" do
      it "delete une galerie, redirige l'user (302) et valide le test" do
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete admin_gallery_path(gallery)
        }.to change(Gallery, :count).by(-1) # Ici permet de vérifier que la galerie est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end
end
