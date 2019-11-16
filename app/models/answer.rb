class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
 
  validates :body, presence: true
  validate :validate_is_best_count

  def mark_as_the_best!
    Answer.transaction do
      self.question.answers.update_all(is_best: false)
      self.update!(is_best: true)
    end
  end

  private

  def validate_is_best_count
    errors.add(:mark_as_the_best!, 'within question best answers too much') unless Answer.where(question: question, is_best: true).blank?
  end
end
