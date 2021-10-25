class NotifyAuthorOfQuestionMailer < ApplicationMailer
  def send_email(user)
    mail to: user.email, from: 'from@example.org', subject: 'You got a new answer to your question' 
  end
end
