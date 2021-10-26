module Services
  class NotifySubscribedUsers
    def self.notify(object)
      question = Question.find(object.question_id)

      User.subscribed_users(question).find_in_batches(batch_size: 500) do |group|
        group.uniq.each do |user|
          if user.author_of?(question)
            NotifyAuthorOfQuestionMailer.send_email(user).deliver_later
          else
            NotifySubscribedUsersMailer.send_email(user).deliver_later
          end
        end
      end
    end
  end
end
