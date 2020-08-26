class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :bounties
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

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
end
