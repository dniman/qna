class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.last_24_hours
    
    mail to: user.email, from: 'from@example.org', subject: 'Daily Digest of questions' 
  end
end
