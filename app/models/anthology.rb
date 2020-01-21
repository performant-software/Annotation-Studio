class Anthology < ActiveRecord::Base
  extend FriendlyId
  has_and_belongs_to_many :documents
  has_and_belongs_to_many :users, join_table: 'users_anthologies'
  belongs_to :user
  friendly_id :name, use: :slugged
  belongs_to :user
end
