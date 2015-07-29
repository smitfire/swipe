class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :author
      t.string :title
      t.integer :rating
      t.text :summary
      t.integer :user_id, index: true
      t.attachment :cover
      t.string :covrl

      t.timestamps null: false
    end
  end
end
