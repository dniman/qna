class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable
  include Subscriptionable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :bounty, dependent: :destroy

  has_many_attached :files
  accepts_nested_attributes_for :bounty

  scope :last_24_hours, ->{ where("date(created_at) = '#{(Date.today - 1).to_formatted_s(:number)}'") }

  validates :title, :body, presence: true

  after_create :subscribe_author!

  private

    def subscribe_author!
      self.user.subscribe!(self)
    end
end
