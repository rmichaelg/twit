class InviteRequestMailer < ActionMailer::Base
  default from: 'The Lifelist Team <team@lifeli.st>'

  def invite_requested invite_request
    @invite_request = invite_request
    mail(to: invite_request.email, subject: 'Lifelist: Discover the best way to achieve any goal')
  end
end
