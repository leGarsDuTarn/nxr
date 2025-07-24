require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
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
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
  end

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
    # Appel user avant chaque test, évite un DRY inutile
    user
    # Simule une session admin avec Devise
    sign_in admin
  end

  describe "GET/admin/users" do # Méthode index
    context "Quand un admin est connecté" do
      it " retourne un status 200, affiche le mon des membres et valide le test" do
        get admin_users_path(format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.first_name)
        expect(response.body).to include(user.last_name)
      end
    end
  end

  describe "GET/admin/users/:id" do # Méthode show
    context "Quand un admin est connecté et affiche les détails d'un membre" do
      it "retourne un status 200, affiche les infos d'un membre et valide le test" do
        get admin_user_path(user)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.first_name)
        expect(response.body).to include(user.last_name)
        expect(response.body).to include(user.phone_number)
      end
    end
  end

  describe "GET/admin/users/:id/edit" do # Méthode edit
    context "Quand un admin connecté modifie les infos d'un membre existant" do
      it "modifie les infos d'un membre existant, retourne un status 200 et valide le test" do
        get edit_admin_user_path(user)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/modifier/i) # case insensitive = Modifier ou modifier
      end
    end
  end

  describe "PATCH/admin/users/:id" do # Méthode update
    context "Quand un admin poste les infos d'un membre modifiés" do
      it "poste les infos modifiés d'un membre, redirige l'user (302) et valide le test" do
        updated_params = {
          user_name: "testnickname",
          role: "member",
          first_name: "testfirsname",
          last_name: "testlastname",
          email: "test@gmail.com",
          phone_number: "0689562302",
          address: "testaddre",
          post_code: "63000",
          town: "testcity",
          country: "testpays"
        }
        patch admin_user_path(user), params: { user: updated_params }
        user.reload # Recharge les données depuis la DB
        expect(response).to have_http_status(:redirect)
        expect(user.first_name).to eq("testfirsname")
        expect(user.post_code).to eq("63000")
      end
    end
  end

  describe "DELETE/admin/users/:id" do # Méthode destroy
    context "Quand l'admin delete un membre" do
      it "delete un membre, redirige l'user (302) et valide le test" do
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete admin_user_path(user)
        }.to change(User, :count).by(-1) # Ici permet de vérifier que le membre est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end

  describe "GET /admin/users/:id/export" do
    context "Un admin récupère les données d’un user en JSON" do
      it "renvoie un JSON contenant les infos du user" do
        sign_in admin
        get export_admin_user_path(user), as: :json
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["email"]).to eq(user.email)
      end
    end
  end

  describe "GET/user/users" do
    context "Quand un user non admin tente d’accéder à /admin/users" do
      it "redirige vers une page d’erreur ou login" do
        sign_in user
        get admin_users_path
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
