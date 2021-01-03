class Document < ApplicationRecord
    belongs_to :user
    has_many :documents_users
    has_many :users, through: :documents_users, as: :editors
end
