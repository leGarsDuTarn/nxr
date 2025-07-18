require 'rails_helper'

RSpec.describe "Admin::Dashboard", type: :request do
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
    sign_in admin
  end

  describe "GET/admin/dashboard" do # Méthode index
    context "Quand un admin veux aller sur son dashboard" do
      it " retourne un status 200, affiche le dashboard, les events et valide le test" do
        event = Event.create!(
          name: "testname",
          date: Date.today,
          hour: Time.now,
          user: admin
        )
        get admin_dashboard_path(format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("tableau de bord")
        expect(response.body).to include(event.name)
      end
    end
  end
end
