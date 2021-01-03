class AddRevisionToDocument < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :revision, :integer
  end
end
