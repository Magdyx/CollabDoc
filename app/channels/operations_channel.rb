class OperationsChannel < ApplicationCable::Channel
  def subscribed
    document = Document.find(params[:id])
    stream_for document
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
