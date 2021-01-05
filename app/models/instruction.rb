class Instruction < ApplicationRecord
    enum status: [:ins, :del]
    belongs_to :operation
end
