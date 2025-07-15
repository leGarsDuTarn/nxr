require 'rails_helper'

RSpec.describe User, type: :model do
  it "valide le test avec tout les champs remplis et valide avec un mot de pass fort" do
    user = User.new(
      user_name: "leGarsDuTarn",
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    expect(user).to be_valid
  end
  it "ne valide pas le test si user_name absent" do
    user = User.new(
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    user.validate
    expect(user.errors[:user_name]).to include("Vous devez renseigner un nom d'utilisateur")
  end
  it "ne valide pas le test si user_name n'est pas unique + case sensitive" do
    # Création du premier user pour tester l'unicité nb -> il sera rollback a la fin
    User.create!(
      user_name: "leGarsDuTarn",
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    # Test avec création d'un deuxième user avec le même user_name
    user = User.new(
      user_name: "legarsdutarn",
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    user.validate
    expect(user.errors[:user_name]).to include("Ce nom d'utilisateur est déjà pris")
  end

  it "ne valide pas le test si first_name absent" do
    user = User.new(
      user_name: "crossandbell",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    user.validate
    expect(user.errors[:first_name]).to include("Vous devez renseigner un prénom")
  end

  it "ne valide pas le test si last_name absent" do
    user = User.new(
      user_name: "crossandbell",
      first_name: "Benjamin",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
   )
    user.validate
    expect(user.errors[:last_name]).to include("Vous devez renseigner un nom")
  end

  it "ne valide pas le test si email est absent" do
    user = User.new(
      user_name: "haley",
      first_name: "Benjamin",
      last_name: "Grassiano",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    user.validate
    expect(user.errors[:email]).to include("Vous devez renseigner un email")
  end

  it "ne valide pas le test si email est mal renseigné" do
    user = User.new(
      user_name: "hello",
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben.gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    user.validate
    expect(user.errors[:email]).to include("exemple : john@gmail.com")
  end

  it "ne valide pas le test avec un phone_number mal renseigné" do
    user = User.new(
      user_name: "legarsdusud",
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      phone_number: "167845612",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    user.validate
    expect(user.errors[:phone_number]).to include("format invalide - 10 chiffres sans espace (ex: 0612345678)")
  end

  it "ne valide pas le test avec un phone_number non renseigné" do
    user = User.new(
      user_name: "viveletarn",
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
    user.validate
    expect(user.errors[:phone_number]).to include("Vous devez renseigner un numéro de téléphone")
  end

  it "ne valide pas le test avec un password mal renseigné" do
    user = User.new(
      user_name: "bella",
      first_name: "Benjamin",
      last_name: "Grassiano",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "faible1",
      password_confirmation: "faible1"
    )
    user.validate
    expect(user.errors[:password]).to include("Doit contenir au moins 8 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial")
  end
end
