class Operation < ApplicationRecord
    belongs_to :user
    belongs_to :document
    has_many :instructions, dependent: :destroy

    accept_nested_attributes_for :instructions
end
