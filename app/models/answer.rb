class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable
  
  belongs_to :question, touch: true
  belongs_to :user

  has_many_attached :files

  default_scope { order(best_answer: :desc).order(:created_at) }

  validates :body, presence: true
  validates :question_id, uniqueness: { scope: :best_answer }, if: :best_answer?

  after_create :notify_subscribed_users

  def mark_as_the_best_answer!
    transaction do
      self.question.answers.update_all(best_answer: false)
      self.question.bounty&.update(user: self.user)
      self.reload
      self.update!(best_answer: true)
    end
  end

  private
    
    def notify_subscribed_users
      NotifySubscribedUsersJob.perform_later(self)
    end
end
