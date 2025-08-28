require 'rails_helper'

RSpec.describe 'Members::Races', type: :request do
  let(:member) do
    User.create!(
      user_name: "testuser_name",
      role: "member",
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

  let(:race) do
    Race.create!(
      name: "testname",
      description: "testdes",
      date: Date.today,
      hour: Time.now,
      user: member
    )
  end

  let!(:registration) do
    Registration.create!(
      user: member,
      registerable: race,
      bike_brand: "KTM",
      cylinder_capacity: 50,
      race_number: "153"
    )
  end

  before do
    # Appel race avant chaque test, évite un DRY inutile
    race
    # Simule une session admin avec Devise
    sign_in member
  end

  describe "GET/members/races" do # Méthode index
    context "Quand un membre est connecté" do
      it " retourne un status 200, affiche le mon des courses et valide le test" do
        get members_races_path(format: :html)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(race.name)
      end
    end
  end

  describe "GET/members/races/:id" do # Méthode show
    context "Quand un membre est connecté et affiche les détails d'une course" do
      it "retourne un status 200, affiche le nom et la description d'une course et valide le test" do
        get members_race_path(race)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(race.name)
        expect(response.body).to include(race.description)
      end
    end
  end

  describe "DELETE/members/races/:race_id/registrations/:id" do # Méthode destroy
    context "Quand un membre supprime son inscription d'une course" do
      it "delete une inscription à une course, redirige l'user (302) et valide le test" do
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete members_race_registration_path(race, registration)
        }.to change(Registration, :count).by(-1) # Ici permet de vérifier que la course est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end

end
