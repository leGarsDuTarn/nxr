require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) do
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

  let!(:existing_article) do
    Article.create!(
      title: "Ma belle moto",
      content: "Quand j'étais petit je voulais une moto...",
      user: user,
      image: fixture_file_upload("spec/fixtures/files/event.jpg", "image/jpeg")
    )
  end

  subject do
    described_class.new(
      title: "Mon KTM de feu",
      content: "Quand j'étais petit je voulais une KTM...",
      user: user
    )
  end

  before do
    # par défaut on attache une image au subject
    subject.image.attach(
      io: File.open(Rails.root.join("spec/fixtures/files/event.jpg")),
      filename: "test_image_article.jpg",
      content_type: "image/jpeg"
    )
  end

  context "Quand tous les champs sont correctement remplis" do
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
    before { subject.title = existing_article.title }
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

  context "Quand l'image est absente" do
    before { subject.image.detach }

    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:image]).to include("Vous devez ajouter une image")
    end
  end
end
