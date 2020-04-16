class Anthology < ActiveRecord::Base
  extend FriendlyId
  has_and_belongs_to_many :documents
  has_attached_file :banner,
                     styles: {
    medium: ["1100x250>", :jpg],
  }
  validates_attachment_content_type :banner, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validate :check_content_type
  validate :check_file_size
  has_and_belongs_to_many :users, join_table: 'users_anthologies'
  belongs_to :user
  friendly_id :name, use: :slugged
  belongs_to :user
  attr_accessor :error_messages

  def check_content_type
    if self.banner_content_type.present?
      if !['image/jpg', 'image/jpeg', 'image/gif','image/png'].include?(self.banner_content_type)
        errors.add(:banner, "File '#{self.banner_file_name}' is not a valid image type")
        unless self.error_messages
          self.error_messages =  "File '#{self.banner_file_name}' is not a valid image type"
        else
          self.error_messages =  "#{self.error_messages} and File '#{self.banner_file_name}' is not a valid image type"
        end
      end
    end
  end

  def check_file_size
    if self.banner_file_size.present?
      if !( self.banner_file_size < 1.megabytes )
        errors.add(:banner, "File is too big")
        unless self.error_messages
          self.error_messages =  "File '#{self.banner_file_name}' should be less than 1 MB"
        else
          self.error_messages =  "#{self.error_messages} and File '#{self.banner_file_name}' should be less than 1 MB"
        end
      end
    end
  end
end
