class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
 
  validates :body, presence: true
  validates :question_id, uniqueness: { scope: :is_best }, if: :is_best?

  def mark_as_the_best!
    transaction do
      self.question.answers.update_all(is_best: false)
      self.update!(is_best: true)
    end
  end
end
