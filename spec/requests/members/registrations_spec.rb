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
      it "retourne un status 200, affiche le nom de l'activité, le formulaire d'inscription,
      les champs obligatoires et valide le test" do
        get new_members_event_registration_path(event)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/inscription/i) # case insensitive = Inscription ou inscription
        expect(response.body).to include(event.name)
        # vérifie ici que le formulaire HTML contient bien les champs cachés nécessaires
        # pour que l'inscription soit correctement reliée à un événement (comme une course).
        # Ces champs sont indispensables à cause de l'association polymorphe `registerable`
        # dans le modèle Registration.
        expect(response.body).to include('name="registration[registerable_id]"')
        expect(response.body).to include('name="registration[registerable_type]"')
      end
    end
  end

  describe "GET /members/race/:race_id/new/registration" do # Méthode new race
    context "Quand un membre accéde au formulaire d'inscription d'une activité de type race" do
      it "retourne un status 200, affiche le nom de l'activité, le formulaire d'inscription,
      les champs obligatoires et valide le test" do
        get new_members_race_registration_path(race)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(race.name)
        # vérifie ici que le formulaire HTML contient bien les champs cachés nécessaires
        # pour que l'inscription soit correctement reliée à un événement (comme une course).
        # Ces champs sont indispensables à cause de l'association polymorphe `registerable`
        # dans le modèle Registration.
        expect(response.body).to include('name="registration[registerable_id]"')
        expect(response.body).to include('name="registration[registerable_type]"')
      end
    end
  end

  describe "GET /members/training/:training_id/new/registration" do # Méthode new training
    context "Quand un membre accéde au formulaire d'inscription d'une activité de type training" do
      it "retourne un status 200, affiche le nom de l'activité, le formulaire d'inscription,
      les champs obligatoires et valide le test" do
        get new_members_training_registration_path(training)
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/inscription/i) # case insensitive = Inscription ou inscription
        expect(response.body).to include(training.name)
        # vérifie ici que le formulaire HTML contient bien les champs cachés nécessaires
        # pour que l'inscription soit correctement reliée à un événement (comme une course).
        # Ces champs sont indispensables à cause de l'association polymorphe `registerable`
        # dans le modèle Registration.
        expect(response.body).to include('name="registration[registerable_id]"')
        expect(response.body).to include('name="registration[registerable_type]"')
      end
    end
  end

  describe "POST /members/event/:event_id/registration" do # Méthode create event
    context "Quand un membre poste une nouvelle inscription à une activité de type event" do
      it "crée une nouvelle inscription, redirige l'user (302) et valide le test" do
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          post members_event_registrations_path(event), params: {
            registration: { registerable_id: event.id, registerable_type: "Event" }
          }
        }.to change(Registration, :count).by(1) # Ici permet de vérifier que l'inscription à un event est bien créé en DB
        expect(response).to have_http_status(:redirect) # Vérifie que l'user est bien redirigé (302)
        expect(member.registered_events).to include(event) # Vérifie que l'user est bien inscrit à l'event
      end
    end
  end

  describe "POST /members/race/:race_id/registration" do # Méthode create race
    context "Quand un membre poste une nouvelle inscription à une activité de type race" do
      it "crée une nouvelle inscription, redirige l'user (302) et valide le test" do
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          post members_race_registrations_path(race), params: {
            registration: {
              registerable_id: race.id,
              registerable_type: "Race",
              bike_brand: "KTM",
              cylinder_capacity: 50,
              race_number: "153"
            }
          }
        }.to change(Registration, :count).by(1) # Ici permet de vérifier que l'inscription à une race est bien créé en DB
        expect(response).to have_http_status(:redirect) # Vérifie que l'user est bien redirigé (302)
        member.reload # recharge depuis la DB
        expect(member.registered_races).to include(race) # Vérifie que l'user est bien inscrit à la race
      end
    end
  end

  describe "POST /members/training/:training_id/registration" do # Méthode create training
    context "Quand un membre poste une nouvelle inscription à une activité de type training" do
      it "crée une nouvelle inscription, redirige l'user (302) et valide le test" do
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          post members_training_registrations_path(training), params: {
            registration: { registerable_id: training.id, registerable_type: "Training" }
          }
        }.to change(Registration, :count).by(1) # Ici permet de vérifier que l'inscription à un training est bien créé en DB
        expect(response).to have_http_status(:redirect) # Vérifie que l'user est bien redirigé (302)
        member.reload # recharge depuis la DB
        expect(member.registered_trainings).to include(training) # Vérifie que l'user est bien inscrit au training
      end
    end
  end
  describe "DELETE /members/event/:event_id/registration/:id" do # Méthode destroy event
    context "Quand le membre supprime son inscription lié à événement de type event" do
      it "supprime l'inscription, redirige l'user (302), et valide le test" do
        # Crée une inscription qui sera supprimée pour le test
        registration = Registration.create!(user: member, registerable: event)
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete members_event_registration_path(event, registration)
        }.to change(Registration, :count).by(-1) # Ici permet de vérifier que l'inscription est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end

  describe "DELETE /member/race/:race_id/registration/:id" do # Méthode destroy race
    context "Quand le membre supprime son inscription lié à événement de type race" do
      it "supprime l'inscription, redirige l'user (302), et valide le test" do
        # Crée une inscription qui sera supprimée pour le test
        registration = Registration.create!(
          user: member,
          registerable: race,
          bike_brand: "KTM",
          cylinder_capacity: 50,
          race_number: "153"
        )
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete members_race_registration_path(race, registration)
        }.to change(Registration, :count).by(-1) # Ici permet de vérifier que l'inscription est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end

  describe "DELETE /member/training/:training_id/registration/:id" do # Méthode destroy training
    context "Quand le membre supprime son inscription lié à événement de type training" do
      it "supprime l'inscription, redirige l'user (302), et valide le test" do
        # Crée une inscription qui sera supprimée pour le test
        registration = Registration.create!(user: member, registerable: training)
        # expect {...} permet de tester un changement d'état, test les créations et suppressions
        expect {
          delete members_training_registration_path(training, registration)
        }.to change(Registration, :count).by(-1) # Ici permet de vérifier que l'inscription est bien supprimé en DB
        expect(response).to have_http_status(:redirect) # Redirige l'user après suppression (302)
      end
    end
  end
end
