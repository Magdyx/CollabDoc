class Document < ApplicationRecord
    belongs_to :creator, class_name: :User, foreign_key: :user_id
    has_many :operations
    has_many :documents_users
    has_many :users, through: :documents_users
end
