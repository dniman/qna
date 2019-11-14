class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true

  def mark_as_the_best
    self.update(is_best: 1)
    self.question.answers.where.not(id: self.id).update_all(is_best: 0)
  end
end
