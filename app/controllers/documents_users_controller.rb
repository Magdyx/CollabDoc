class DocumentsUsersController < ApplicationController 
  load_and_authorize_resource only: [:new, :create, :index]
  load_and_authorize_resource :document

  def create
    @documents_user.save!
    render :index
  end

  def destroy
    @user = User.find(params[:id]) 
    @document.users.delete(@user)
    render :index
  end

  def index
    @editors = @document.users
    @usersToAdd = User.where.not(id: @document.editors)
  end

  private

  def documents_user_params
    params[:documents_user][:document_id] = params[:document_id]
    params.require(:documents_user).permit(:user_id, :document_id)
  end
end
