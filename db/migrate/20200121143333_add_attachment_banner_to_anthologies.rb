class AddAttachmentBannerToAnthologies < ActiveRecord::Migration
  def self.up
    change_table :anthologies do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :anthologies, :banner
  end
end
