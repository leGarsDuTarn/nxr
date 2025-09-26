module Public
  class ContactsController < BaseController
    def new
      @contact = ContactMessage.new
    end

    def create
      @contact = ContactMessage.new(contact_params)

      if @contact.valid?
        club = Club.first

        # Le Hash permet d'éviter d'éventuel erreur de serialization
        message_data = {
          name: @contact.name,
          email: @contact.email,
          body: @contact.body
        }

        # Mail au responsable du club
        ContactMailer.with(message: message_data, club: club).send_to_admin.deliver_later
        # Mail de confirmation à l’utilisateur
        ContactMailer.with(message: message_data, club: club).confirmation_to_user.deliver_later

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
