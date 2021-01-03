class AddDocumentIdToOperation < ActiveRecord::Migration[6.1]
  def change
    add_column :operations, :document_id, :integer
  end
end
