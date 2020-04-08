class Anthology < ActiveRecord::Base
  extend FriendlyId
  has_and_belongs_to_many :documents
  has_attached_file :banner,
                     styles: {
    medium: ["1100x250>", :jpg],
  }
  validates_attachment_content_type :banner, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_with AttachmentSizeValidator, attributes: :banner, less_than: 1.megabytes
  has_and_belongs_to_many :users, join_table: 'users_anthologies'
  belongs_to :user
  friendly_id :name, use: :slugged
  belongs_to :user
end
