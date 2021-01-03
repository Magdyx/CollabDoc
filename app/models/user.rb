class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :documents
  has_many :documents_users
  has_many :shared_documents, through: :documents_users, as: :documents
end
