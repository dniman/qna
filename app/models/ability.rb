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

    can [:vote_yes, :vote_no, :cancel_vote], [Question, Answer] do |resource|
      resource.user_id != user.id
    end

    can :destroy, Link do |link|
      link.linkable.user_id == user.id
    end
    
    can :destroy, ActiveStorage::Attachment do |attachment|
      attachment.record.user_id == user.id
    end

    can :create, Bounty do |bounty|
      bounty.question.user_id == user.id
    end
  end
end
