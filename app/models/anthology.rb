class Anthology < ActiveRecord::Base
  extend FriendlyId
  has_and_belongs_to_many :documents
  has_attached_file :banner,
                     styles: {
    medium: ["3000x420>", :jpg],
    small: ["1000x96>", :jpg],
    thumb: ["800x45#", :jpg]
  }
  validates_attachment_content_type :banner, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_and_belongs_to_many :users, join_table: 'users_anthologies'
  belongs_to :user
  friendly_id :name, use: :slugged
  belongs_to :user
end
