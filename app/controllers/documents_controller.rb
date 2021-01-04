class DocumentsController < ApplicationController
  load_and_authorize_resource

  def create
    @document = current_user.documents.create(title: "untitled", content: "", user_id: current_user.id)
    redirect_to document_path(@document.id)
  end
end