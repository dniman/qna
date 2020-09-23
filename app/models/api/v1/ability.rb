class Api::V1::Ability
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
    can :create, [Question, Answer]
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can [:me], User do |me|
      me == user
    end
    can [:others], User do |other|
      other != user
    end
  end
end
