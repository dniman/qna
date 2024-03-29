class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :bounties
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :oauth_providers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  scope :subscribed_users, ->(question) do 
    joins(:subscriptions)
      .where("subscriptions.question_id = ?", question)
  end

  def author_of?(resource)
    resource.user_id == self.id
  end

  def voted_for?(resource)
    votes.exists?(votable: resource)
  end

  def voted_for_up?(resource)
    votes.exists?(votable: resource, yes: 1)
  end
  
  def voted_for_down?(resource)
    votes.exists?(votable: resource, yes: -1)
  end
  
  def vote_yes!(resource)
    self.votes.create!(votable: resource, yes: 1)
  end
  
  def vote_no!(resource)
    self.votes.create!(votable: resource, yes: -1)
  end
  
  def cancel_vote!(resource)
    vote = self.votes.where(votable: resource)
    self.votes.delete(vote)
  end

  def self.find_for_oauth(auth, email = nil)
    Services::FindForOauth.new(auth, email).call
  end
  
  def subscribed_to?(question)
    self.subscriptions.exists?(question: question)
  end

  def subscribe!(question)
    self.subscriptions.create!(question: question)
  end

  def unsubscribe!(question)
    subscription = self.subscriptions.where(question: question)
    self.subscriptions.delete(subscription)
  end
end
