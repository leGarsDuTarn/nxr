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


  it "valide le test avec tous les champs remplis et valide avec un mot de pass fort" do
    user.validate # Déclenche les validations
    expect(user).to be_valid
  end
  it "ne valide pas le test si user_name absent" do
    user.user_name = nil
    user.validate # Déclenche les validations
    expect(user).not_to be_valid # L’objet doit être invalide
    # Vérifie le bon message d’erreur
    expect(user.errors[:user_name]).to include("Vous devez renseigner un nom d'utilisateur")
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
    # Test avec création d'un deuxième user avec le même user_name mais en minuscule
    user.user_name = "legarsdutarn"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:user_name]).to include("Ce nom d'utilisateur est déjà pris")
  end

  it "ne valide pas le test si first_name absent" do
    user.first_name = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include("Vous devez renseigner un prénom")
  end

  it "ne valide pas le test si last_name absent" do
    user.last_name = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include("Vous devez renseigner un nom")
  end

  it "ne valide pas le test si email est absent" do
    user.email = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("Vous devez renseigner un email")
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
    expect(user.errors[:phone_number]).to include("format invalide - 10 chiffres sans espace (ex: 0612345678)")
  end

  it "ne valide pas le test avec un phone_number non renseigné" do
    user.phone_number = nil
    user.validate
    expect(user.errors[:phone_number]).to include("Vous devez renseigner un numéro de téléphone")
  end

  it "ne valide pas le test avec un password mal renseigné" do
    user.password = "exempl1"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("Doit contenir au moins 8 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial")
  end

  it "ne valide pas le test avec un birth_date non renseigné" do
    user.birth_date = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:birth_date]).to include("Vous devez renseigner une date de naissance")
  end

  it "ne valide pas le test avec un license_code non renseigné" do
    user.license_code = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_code]).to include("Vous devez renseigner un code de licence valide")
  end

  it "ne valide pas le test avec un license_code mal renseigné" do
    user.license_code = "FFF"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_code]).to include("Vous devez renseigner un code de licence valide")
  end

  it "ne valide pas le test avec un license_number non renseigné" do
    user.license_number = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_number]).to include("Vous devez renseigner un numéro de licence valide")
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
    # Test avec création d'un deuxième user avec le même numéro de licence avec case sensitive
    user.license_number = "123456 "
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_number]).to include("Ce numéro de licence existe déjà")
  end

  it "ne valide pas le test avec un license_number mal renseigné" do
    user.license_code = "1234"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:license_number]).to include("Le numéro de licence doit contenir 6 chiffres")
  end
  it "ne valide pas le test si plate_number n'est pas unique" do
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
      country: "France",
      license_code: "NCO",
      license_number: "123456",
      club_member: true,
      club_name: "testclubname",
      bike_brand: "KTM",
      cylinder_capacity: 50,
      stroke_type: "2T",
      plate_number: "AB-123-CD",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    # Test avec création d'un deuxième user avec le même numéro de plaque d'immatriculation avec case sensitive
    user.plate_number = "AB-123-CD"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:plate_number]).to include("Ce numéro de plaque d'imatriculation existe déjà")
  end

  it "ne valide pas le test avec un plate_number mal renseigné" do
    user.license_code = "abc123dc"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:plate_number]).to include("Format de plaque invalide (ex: AB-123-CD)")
  end
  it "ne valide pas le test avec un cylinder_capacity inférieur à 50" do
    user.cylinder_capacity = 49
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:cylinder_capacity]).to include("La cylindrée doit-être supérieure à 50cc")
  end

  it "ne valide pas le test si club_member n'est pas renseigné" do
    user.club_member = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:club_member]).to include("vous devez sélectionner 'oui' ou 'non'")
  end

  it "ne valide pas le test si club_name n'est pas renseigné" do
    user.club_name = nil
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:club_name]).to include("Vous devez renseigner le nom de votre club")
  end

  it "ne valide pas le test si bike_brand est mal renseigné" do
    user.bike_brand = "Harley"
    user.validate
    expect(user).not_to be_valid
    expect(user.errors[:bike_brand]).to include("n'est pas inclus dans la liste")
  end
end
