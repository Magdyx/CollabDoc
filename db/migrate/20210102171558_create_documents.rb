class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :content
      t.belongs_to :user
      t.timestamps
    end
  end
end
