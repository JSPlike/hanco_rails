class WebmailMailer < ApplicationMailer
    def invite_email_send(to_user,from_user,data)
        @invite = data
        mail(from: to_user,
            to: from_user,
            subject: 'hi')
    end
end
