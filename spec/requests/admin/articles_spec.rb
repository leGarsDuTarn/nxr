require 'rails_helper'

RSpec.describe "Admin::Articles", type: :request do
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
      town: "Paris",
      country: "France",
      license_code: "NCO",
      license_number: "123456",
      club_member: true,
      club_affiliation_number: "C0637",
      club_name: "testclubname",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
  end

  let(:article) do
    Article.create!(
      title: "testtitle",
      content: "testcontent",
      date: Date.today,
      user: admin
    )
  end

  before do
    # Simule une session admin avec Devise
    sign_in admin
    # Appel article avant chaque test, évite un DRY inutile
    article
  end

  describe "GET/admin/articles" do # Méthode index
    context "Quand un admin est connecté" do
      it " retourne un status 200, affiche le titre des articles et valide le test" do
        get admin_articles_path(format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(article.title)
      end
    end
  end

  describe "GET/admin/aticles/:id" do # Méthode show
    context "Quand un admin est connecté et affiche un article" do
      it "retourne un status 200, affiche le nom et le contenu d'un article et valide le test" do
        get admin_article_path(article)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(article.title)
        expect(response.body).to include(article.content)
      end
    end
  end

  describe "GET/admin/articles/new" do # Méthode new
    context "Quand un admin est connecté et crée un nouvel article" do
      it "retourne un status 200 et valide le test" do
        get new_admin_article_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("article")
      end
    end
  end

  describe "POST /admin/articles" do # Méthode create
    context "Quand un admin connecté poste un nouvel article" do
      it "crée un nouvel article avec une image liée, redirige l'user (302) et valide le test" do
        # Permet de charger une image depuis le fichier de test fixtures
        file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg")
        article_params = {
          title: "testarticle",
          content: "testcontent",
          date: Date.today,
          image: file
        }
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          post admin_articles_path, params: { article: article_params }
        }.to change(Article, :count).by(1) # Ici permet de vérifier que l'article est bien créé en DB
        expect(Article.last.image).to be_attached # Ici verifie que l'image est bien attaché
        expect(response).to have_http_status(:redirect) # Vérifie que l'user est bien redirigé (302)
        expect(Article.last.title).to eq("testarticle") # Vérifie que 'test' est le titre attribué à l'article posté
      end
    end
  end

  describe "GET/admin/articls/:id/edit" do # Méthode edit
    context "Quand un admin connecté modifie un article existant" do
      it "modifie un article existant, retourne un status 200 et valide le test" do
        get edit_admin_article_path(article)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/modifier/i) # case insensitive = Modifier ou modifier
      end
    end
  end

  describe "PATCH/admin/articles/:id" do # Méthode update
    context "Quand un admin poste un article modifié" do
      it "poste un article modifié avec image, redirige l'user (302) et valide le test" do
        # Permet de charger une iamge depuis le fichier de test fixtures
        file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "event.jpg"), "image/jpeg")

        updated_params = {
          title: "testupdate",
          content: "testuptodate",
          date: Date.today,
          image: file
        }
        patch admin_article_path(article), params: { article: updated_params }
        article.reload # Recharge les données depuis la DB
        expect(response).to have_http_status(:redirect)
        expect(article.image).to be_attached
        expect(article.title).to eq("testupdate")
      end
    end
  end

  describe "DELETE/admin/articles/:id" do # Méthode destroy
    context "Quand l'admin delete un article" do
      it "delete un article, redirige l'user (302) et valide le test" do
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete admin_article_path(article)
        }.to change(Article, :count).by(-1) # Ici permet de vérifier que l'article est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end
end
