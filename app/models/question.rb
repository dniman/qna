class Question < ApplicationRecord
  include Linkable
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :bounty, dependent: :destroy

  has_many_attached :files
  accepts_nested_attributes_for :bounty

  validates :title, :body, presence: true
end
