class Instruction < ApplicationRecord
    enum kind: [:insert, :delete]
    belongs_to :operation
end
