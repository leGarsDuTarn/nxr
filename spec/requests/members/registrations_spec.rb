require 'rails_helper'

RSpec.describe "Members::Registrations", type: :request do
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
      user: member
    )
  end

  let(:event) do
    Event.create!(
      name: "testname",
      description: "testdescription",
      date: Date.today,
      hour: Time.now,
      user: member
    )
  end

  let(:training) do
    Training.create!(
      name: "testname",
      description: "testdes",
      date: Date.today,
      hour: Time.now,
      user: member
    )
  end

  before do
    # Simule une session member avec Devise
    sign_in member
    # Appel event avant chaque test, évite un DRY inutile
    event
    # Appel race avant chaque test, évite un DRY inutile
    race
    # Appel training avant chaque test, évite un DRY inutile
    training
  end

  describe "GET /members/event/:event_id/new/registration" do # Méthode new event
    context "Quand un membre accéde au formulaire d'inscription d'une activité de type event" do
      it "retourne un status 200, affiche le nom de l'activité, le formulaire d'inscription et valide le test" do
        get new_member_event_registration_path(event)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/inscription/i) # case insensitive = Inscription ou inscription
        expect(response.body).to include(event.name)
        expect(response.body).to include('<form') # Vérifie qu'un formulaire est bien affiché
      end
    end
  end

  describe "GET /members/race/:race_id/new/registration" do # Méthode new race
    context "Quand un membre accéde au formulaire d'inscription d'une activité de type race" do
      it "retourne un status 200, affiche le nom de l'activité, le formulaire d'inscription et valide le test" do
        get new_member_event_registration_path(event)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/inscription/i) # case insensitive = Inscription ou inscription
        expect(response.body).to include(race.name)
        expect(response.body).to include('<form') # Vérifie qu'un formulaire est bien affiché
      end
    end
  end

  describe "GET /members/training/:training_id/new/registration" do # Méthode new training
    context "Quand un membre accéde au formulaire d'inscription d'une activité de type training" do
      it "retourne un status 200, affiche le nom de l'activité, le formulaire d'inscription et valide le test" do
        get new_member_training_registration_path(training)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/inscription/i) # case insensitive = Inscription ou inscription
        expect(response.body).to include(training.name)
        expect(response.body).to include('<form') # Vérifie qu'un formulaire est bien affiché
      end
    end
  end

  describe "POST /members/event/:event_id/registration" do # Méthode create event
    context "Quand un membre poste une nouvelle inscription à une activité de type event" do
      it "crée une nouvelle inscription, redirige l'user (302) et valide le test" do
        race_params = {
          name: "testrace",
          description: "testdescription",
          date: Date.today,
          hour: Time.now,
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
end
