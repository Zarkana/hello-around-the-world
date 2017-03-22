class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Snippet, user_id: user.id
    can :manage, Category, user_id: user.id
    can :manage, Language, user_id: user.id
  end
end
