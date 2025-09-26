module Public
  class ContactsController < ApplicationController
    def new
      @contact = ContactMessage.new
    end

    def create
      @contact = ContactMessage.new(contact_params)

      if @contact.valid?
        club = Club.first

        # Mail au responsable du club
        ContactMailer.with(message: @contact, club: club).send_to_admin.deliver_later
        # Mail de confirmation à l’utilisateur
        ContactMailer.with(message: @contact, club: club).confirmation_to_user.deliver_later

        redirect_to new_public_contact_path, notice: "Votre message a bien été envoyé."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def contact_params
      params.require(:contact_message).permit(:name, :email, :body)
    end
  end
end
