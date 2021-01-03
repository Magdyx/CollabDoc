class AddOperation < ActiveRecord::Migration[6.1]
  def change
    create_table :operations do |t|
      t.integer :revision
      t.belongs_to :user
      t.timestamps
    end
    
  end
end
