class OperationsController < ApplicationController
  load_and_authorize_resource
  def create
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
    puts(params)
    params.require(:operation).permit(:revision, :document_id, instruction: [:kind, :character, :position])
  end

  def transform_operation

  end

  def broadcast_operation

  end
end