class Ability
  include CanCan::Ability
  include Repertoire::Groups::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # If CanCan doesn't find a match for the above, it falls through
    # to the default abilities provided by Repertoire Groups:
    defaults_for user

    if user.has_role? :admin
      can :manage, :all

    elsif user.has_role? :teacher
      cannot :manage, Document do |tors|
        if tors.user.nil?
          false
        else
          tors.user.id == user.id
        end
      end
      can [:read, :create], Document
      can [:read, :update, :annotatable, :review, :publish, :archive, :preview, :post_to_cove, :export, :set_default_state, :snapshot, :anthology_add], Document, { :user_id => user.id }
      cannot :manage, Anthology
      can :manage, Anthology, { :user_id => user.id }
      can [:read], Anthology
      can :destroy, Document, { :user_id => user.id, :published? => false }

    elsif user.has_role? :student
      cannot :manage, Document
      can [:read, :create], Document
      can [:read, :update, :anthology_add, :preview, :snapshot, :export], Document, { :user_id => user.id }
      cannot :manage, Anthology
      can :manage, Anthology, { :user_id => user.id }
      can [:read], Anthology
      can :destroy, Document, { :user_id => user.id, :published? => false }
      can :read, Document do |tors|
        !(user.rep_group_list & tors.rep_group_list).empty?
      end
      cannot :manage, User
    else
      cannot :manage, :all
      can :read, Document, { :public? => true }
    end

    can :index, Document
  end
end
