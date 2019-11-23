class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  default_scope { order(best_answer: :desc).order(:created_at) }

  validates :body, presence: true
  validates :question_id, uniqueness: { scope: :best_answer }, if: :best_answer?

  def mark_as_the_best_answer!
    transaction do
      self.question.answers.update_all(best_answer: false)
      self.update!(best_answer: true)
    end
  end
end
