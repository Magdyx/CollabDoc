class DocumentsController < ApplicationController
  load_and_authorize_resource

  def create
    @document = current_user.own_documents.create(title: "untitled", content: "")
    redirect_to document_path(@document.id)
  end
end