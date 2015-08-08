class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :author
      t.string :title

      t.string :isbn
      t.string :isbn13
      t.string :asin
      
      t.string :image_url
      t.string :small_image_url
      
      t.integer :publication_year
      t.integer :publication_month
      t.integer :publication_day
      
      # t.string :genre
      t.string :publisher
      
      t.string :language_code
      t.boolean :is_ebook
      
      t.text :description
      
      t.integer :average_rating
      
      t.integer :num_pages
      t.string :format
      t.string :edition_information
      t.string :ratings_count
      t.integer :text_reviews_count
      
      t.string :url
      t.string :link
      
      t.integer :user_id, index: true
      # t.attachment :cover
      # t.string :covrl

      t.timestamps null: false
    end
  end
end
