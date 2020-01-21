class CreateUsersAnthologies < ActiveRecord::Migration
  def change
    create_table :users_anthologies do |t|
      t.integer :user_id
      t.integer :anthology_id
    end
    add_index :users_anthologies, :user_id
    add_index :users_anthologies, :anthology_id
  end
end
