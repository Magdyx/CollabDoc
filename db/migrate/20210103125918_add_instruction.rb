class AddInstruction < ActiveRecord::Migration[6.1]
  def change
    create_table :instructions do |t|
      t.integer :kind
      t.string :character
      t.integer :position
      t.belongs_to :operation
      t.timestamps
    end
    
  end
end
