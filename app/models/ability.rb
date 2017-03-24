class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Snippet, user_id: user.id
    can :new, Snippet
    can :manage, Category, user_id: user.id
    can :new, Category
    can :manage, Language, user_id: user.id
    can :new, Language
    can :manage, Implementation, :snippet => { user_id: user.id }
  end
end
