require 'rails_helper'

RSpec.describe "Admin::Dashboard", type: :request do
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
