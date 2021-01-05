class Operation < ApplicationRecord
    belongs_to :user
    belongs_to :document
    has_many :instructions, dependent: :destroy

    accepts_nested_attributes_for :instructions

    scope :operations_later_than, ->(rev) { where("revision > ?", rev).pluck(:id)}
end
