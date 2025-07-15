require 'rails_helper'

RSpec.describe User, type: :model do
  it "valide le test avec des champs remplis et valide avec un mot de pass fort" do
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
end
