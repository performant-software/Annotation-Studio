class Anthology < ActiveRecord::Base
  extend FriendlyId
  has_and_belongs_to_many :documents
  friendly_id :name, use: :slugged
  belongs_to :user
end
