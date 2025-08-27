require 'rails_helper'

RSpec.describe Gallery, type: :model do
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
  # Avant chaque test, je crée un faux fichier d'image en mémoire
  before do
    subject.images.attach(
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
    gallery.images.attach(
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


  context "Quand tout les champs sont correctement remplis avec des images" do
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

  context "Quand une ou plusieurs images sont absente" do
    before { subject.images = nil }

    it "Le test n'est pas valid" do
      subject.validate
      expect(subject.errors[:images]).to include("Vous devez ajouter une ou plusieurs images")
    end
  end

  context "Quand la date est absente" do
    before { subject.date = nil }

    it "Le test n'est pas valide" do
      subject.validate
      expect(subject.errors[:date]).to include("Vous devez renseigner une date")
    end
  end

  context "Quand une image est supprimée manuellement" do
    before do
      # Supprime l'image par défaut attachée dans le before global
      subject.images.purge
      # Création de deux images pour ce test
      subject.images.attach([
        {
          io: StringIO.new("image 1"),
          filename: "image1.png",
          content_type: "image/png"
        },
        {
          io: StringIO.new("image 2"),
          filename: "image2.png",
          content_type: "image/png"
        }
      ])
      subject.save! # Sauvegarde les deux images en DB
    end

    it "La galerie ne contient plus qu'une seule image après suppression" do
      subject.images.first.purge # Suppression de la première image "image 1"
      subject.reload # Recharge les données depuis la DB

      expect(subject.images.count).to eq(1)
      expect(subject.images.first.filename.to_s).to eq("image2.png") # Valide que l'image restante porte bien ce nom
    end
  end
end
