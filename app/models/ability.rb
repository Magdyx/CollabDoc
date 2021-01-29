# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new  
    @user = user
    edit_his_files
  end

  def edit_his_files
    can :manage, Document, user_id: @user.id
    can :read, Document, users: {id: @user.id}
    can :update, Document, users: {id: @user.id}
    can :manage, DocumentsUser, document: {user_id: @user.id}
    can :create, DocumentsUser
  end
end
