class Document < ApplicationRecord
  include ContentBuilder

  belongs_to :creator, class_name: :User, foreign_key: :user_id
  has_many :operations
  has_many :documents_users, dependent: :destroy
  has_many :users, through: :documents_users

  attribute :revision, :integer, default: 1

  def editors
    documents_users.pluck(:user_id) << user_id
  end

  def users_to_add
    User.where.not(id: editors)
  end
end
