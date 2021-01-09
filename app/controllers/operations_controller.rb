class OperationsController < ApplicationController
  load_and_authorize_resource

  def create
    @operation.user = current_user
    @document = @operation.document

    if @document.revision != @operation.revision
      transform_operation
    end

    @document.apply_operation(@operation)
    @operation.revision = @document.revision
    @operation.save!
    broadcast_operation
  end

  private

  def operation_params
    params[:operation] = JSON.parse(params[:operation])
    params.require(:operation).permit(:revision, :document_id, instructions_attributes: [:status, :character, :position])
  end

  def transform_operation
    #OperationTranformer.transform_operation(@operation, @document)
  end

  def broadcast_operation
    OperationsChannel.broadcast_to(@document, @operation)
  end
end