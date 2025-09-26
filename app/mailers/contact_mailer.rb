class ContactMailer < ApplicationMailer
  # Mail envoyé au bureau du club
  def send_to_admin
    @message = params[:message] # Hash
    @club    = params[:club]    

    mail(
      from: @message[:email], # expéditeur = membre
      to: @club&.email || "motoclubnaves@gmail.com",
      subject: "📩 Nouveau message depuis le site #{@club&.name || 'MCNC'}"
    )
  end

  # Mail de confirmation envoyé au membre
  def confirmation_to_user
    @message = params[:message] # Hash
    @club    = params[:club]

    mail(
      from: @club&.email || "no-reply@mcnc.fr", # expéditeur = club
      to: @message[:email],
      subject: "✅ Confirmation de votre message au #{@club&.name || 'MCNC'}"
    )
  end
end
