class Anthology < ActiveRecord::Base
  extend FriendlyId
  has_many :documents
  friendly_id :name
end
