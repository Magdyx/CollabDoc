class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :own_documents, class_name: "Document"
  has_many :operations
  has_many :documents_users
  has_many :documents , through: :documents_users
end
