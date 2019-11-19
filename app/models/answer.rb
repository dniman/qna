class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  default_scope { order(best_answer: 'desc') }
  default_scope { joins('join answers as a1 on a1.id = answers.id').order('a1.id asc') }

  validates :body, presence: true
  validates :question_id, uniqueness: { scope: :best_answer }, if: :best_answer?

  def mark_as_the_best_answer!
    transaction do
      self.question.answers.update_all(best_answer: false)
      self.update!(best_answer: true)
    end
  end
end
