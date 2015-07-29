class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :liked
      t.belongs_to :user, index: true
      t.belongs_to :book, index: true
      
      t.timestamps null: false
    end
  end
end
