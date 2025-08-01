require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) do
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

  let(:article) do
    Article.create!(
      title: "Ma belle moto",
      content: "Quand j'étais petit je voulais une moto...",
      user: user
    )
  end

  subject do
    described_class.new(
      title: "Ma belle moto",
      content: "Quand j'étais petit je voulais une moto...",
      user: user
    )
  end

  context "Quand tout les champs sont correctement remplis" do
    it "Le test est valide" do
      expect(subject).to be_valid
    end
  end

  context "Quand le titre est absent" do
    before { subject.title = nil }

    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:title]).to include("Vous devez renseigner un titre")
    end
  end

  context "Quand le titre n'est pas unique" do
    before { subject.title = article.title}
    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:title]).to include("Ce titre est déjà utilisé")
    end
  end

  context "Quand le content est absent" do
    before { subject.content = nil }

    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:content]).to include("Vous devez renseigner ce champ")
    end
  end
end
