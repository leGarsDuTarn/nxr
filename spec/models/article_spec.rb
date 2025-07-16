require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) do
    User.create!(
      user_name: "testarticle",
      first_name: "admin",
      last_name: "test",
      email: "ben@gmail.com",
      phone_number: "0678456123",
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
