class Operation < ApplicationRecord
    belongs_to :user
    belongs_to :document
    has_many :instructions
end
