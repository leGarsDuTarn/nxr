require 'rails_helper'

RSpec.describe Gallery, type: :model do
  let(:user) do
    User.create!(
      user_name: "testgallery",
      first_name: "admin",
      last_name: "test",
      email: "ben@gmail.com",
      phone_number: "0678456123",
      password: "Exemples1,",
      password_confirmation: "Exemples1,"
    )
  end
  # Avant chaque test, je crée un faux fichier d'image en mémoire
  before do
    subject.image.attach(
      io: StringIO.new("fake image content"),
      filename: "test_image_gallery.png",
      content_type: "image/png"
    )
  end
  # Création d'une gallery existant pour tester l'unicité
  let(:gallery) do
    gallery = Gallery.new(
      title: "testgallery",
      date: Date.new(2026, 8, 13),
      user: user
    )
    # Je lui attache une fausse image avant de save
    gallery.image.attach(
      io: StringIO.new("fake image content"),
      filename: "test_image_gallery.png",
      content_type: "image/png"
    )
    # Je sauvegarde en base (mais rollback automatique a la fin du test)
    gallery.save!
    # Je retourne la galerie créée
    gallery
  end

  # Object principal testé dans chaque context
  subject do
    described_class.new(
      title: "testgallery",
      date: Date.new(2026, 8, 13),
      user: user
    )
  end


  context "Quand tout les champs sont correctement remplis et que l'image a correctement été ajoutée" do
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
    before { subject.title = gallery.title }

    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:title]).to include("Ce titre est déjà utilisé")
    end
  end

  context "Quand l'image est absente" do
    before { subject.image.detach }

    it "Le test n'est pas valid" do
      subject.validate
      expect(subject.errors[:image]).to include("Vous devez ajouter une image")
    end
  end

  context "Quand la date est absente" do
    before { subject.date = nil }

    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:date]).to include("Vous devez renseigner une date")
    end
  end
end
