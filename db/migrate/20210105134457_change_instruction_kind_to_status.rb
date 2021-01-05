class ChangeInstructionKindToStatus < ActiveRecord::Migration[6.1]
  def change
    rename_column :instructions, :kind, :status
  end
end
