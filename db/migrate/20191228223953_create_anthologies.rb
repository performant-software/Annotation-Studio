class CreateAnthologies < ActiveRecord::Migration
  def change
    create_table :anthologies do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
