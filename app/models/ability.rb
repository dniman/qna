# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can :mark_as_the_best, Answer do |answer|
      user.author_of?(answer.question) 
    end

    can :destroy, 'api/v1/questions', user_id: user.id

    can [:vote_yes, :vote_no, :cancel_vote], [Question, Answer] do |resource|
      !user.author_of?(resource)
    end

    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end
    
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end

    can :create, Bounty do |bounty|
      user.author_of?(bounty.question)
    end
  end
end
