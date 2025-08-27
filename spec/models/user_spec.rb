require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    described_class.new(
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
  it "valide le test avec tous les champs remplis et valide avec un mot de pass fort" do
    user.validate # Déclenche les validations
    expect(user).to be_valid
  end
  it "ne valide pas le test si user_name absent" do
    user.user_name = nil
    user.validate # Déclenche les validations
    expect(user).not_to be_valid # L’objet doit être invalide
    # Vérifie le bon message d’erreur
    expect(user.errors[:user_name]).to include("Veuillez renseigner un nom d'utilisateur.")
  end
  it "ne valide pas le test si user_name n'est pas unique + case sensitive" do
    # Création du premier user pour tester l'unicité nb -> il sera rollback a la fin
    User.create!(
      user_name: "leGarsDuTarn",
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
    # Test avec création d'un deuxième user avec le même user_name mais en minuscule
    user.user_name = "legarsdutarn"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:user_name]).to include("Oups ! Ce nom d'utilisateur est déjà pris.")
  end

  it "ne valide pas le test si first_name absent" do
    user.first_name = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include("Veuillez renseigner un prénom.")
  end

  it "ne valide pas le test si last_name absent" do
    user.last_name = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include("Veuillez renseigner un nom.")
  end

  it "ne valide pas le test si email est absent" do
    user.email = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("Veuillez renseigner un email.")
  end

  it "ne valide pas le test si email est mal renseigné" do
    user.email = "test#mail"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("exemple : john@gmail.com")
  end

  it "ne valide pas le test avec un phone_number mal renseigné" do
    user.phone_number = "060000002"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:phone_number]).to include("Format invalide : 10 chiffres sans espace (ex. : 0612345678).")
  end

  it "ne valide pas le test avec un password mal renseigné" do
    user.password = "exempl1"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("Doit contenir au moins 8 caractères, dont une majuscule, une minuscule, un chiffre et un caractère spécial.")
  end

  it "ne valide pas le test avec un birth_date non renseigné" do
    user.birth_date = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:birth_date]).to include("Veuillez renseigner une date de naissance.")
  end

  it "ne valide pas le test avec un license_code non renseigné" do
    user.license_code = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_code]).to include("Veuillez renseigner un code de licence valide.")
  end

  it "ne valide pas le test avec un license_code mal renseigné" do
    user.license_code = "FFF"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_code]).to include("FFF n’est pas un code de licence FFM valide.")
  end

  it "ne valide pas le test avec un license_number non renseigné" do
    user.license_number = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_number]).to include("Veuillez renseigner un numéro de licence valide.")
  end

  it "ne valide pas le test si license_number n'est pas unique" do
    # Création du premier user pour tester l'unicité nb -> il sera rollback a la fin
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
      club_member: false,
      club_name: "testname",
      club_affiliation_number: "C6563",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    # Test avec création d'un deuxième user avec le même numéro de licence avec case sensitive
    user.license_number = "123456 "
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_number]).to include("Oups ! Ce numéro de licence est déjà attribué.")
  end

  it "ne valide pas le test avec un license_number mal renseigné" do
    user.license_number = "1234"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_number]).to include("Le numéro de licence doit contenir 6 chiffres sans espace.")
  end
  it "ne valide pas le test si club_member n'est pas renseigné" do
    user.club_member = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:club_member]).to include("Veuillez sélectionner 'Oui' ou 'Non'.")
  end

  it "assigne automatiquement 'NAVÈS' si club_member est true et club_name est vide" do
    user.club_member = true
    user.club_name = nil
    user.validate

    expect(user).to be_valid
    expect(user.club_name).to eq("NAVÈS")
  end

  it "ne valide pas si club_member est false et club_name est vide" do
    user.club_member = false
    user.club_name = nil
    user.validate

    expect(user).not_to be_valid
    expect(user.errors[:club_name]).to include("Veuillez renseigner le nom de votre club.")
  end
end
