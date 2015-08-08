class Book < ActiveRecord::Base

  # has_attached_file :cover, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/bkcv.JPG"
  # validates_attachment_content_type :cover, :content_type => /\Aimage/
  # validates_attachment_file_name :cover
  
  belongs_to :owner, class_name: "User", foreign_key: "user_id", inverse_of: :owned_books

  has_many :votes, -> { includes :user }, dependent: :destroy

  has_many :voters, -> { uniq }, through: :votes, source: :user, inverse_of: :voted_books

  has_many :received_likes, -> { where(liked: true) }, class_name: "Vote"

  has_many :unreceived_likes, -> { where(liked: false) }, class_name: "Vote"

  has_many :likers, -> { uniq }, through: :received_likes, source: :user, inverse_of: :liked_books

  has_many :dislikers, -> { uniq }, through: :unreceived_likes, source: :user, inverse_of: :disliked_books

  # has_many :unvisited_users, -> { joins(:votes).where( votes: { user_id: nil } ) }

  # SCOPES
  scope :all_liked_books, -> { joins(:votes).where( "votes.liked = ?", true ) }
  # scope :unvisited_users, -> { joins(:votes).where( votes: { user_id: nil } ) }
  scope :unliked_books_by_user, -> (user_id) { joins(:votes).where( "votes.liked = ? AND votes.user_id != ?", false, user_id ) }
  scope :all_voted, -> { joins(:votes).where('votes.book_id != ?', nil ) }

  

  after_create :sanitize_description, if: :description_present?
  
  # after_save :get_info, if: :title_present?, unless: :description_present?
  
  def self.unviewed_books(user_id)
    Book.where.not(id: User.find(user_id).voted_books.ids, user_id: user_id )
  end

  def location
    [owner.longitude, owner.latitude]
  end


  protected
    def description_present?
      description.present?
    end

    def title_present?
      title.present?
    end

    def sanitize_description
      update(description: ActionView::Base.full_sanitizer.sanitize(description))
    end

    def get_info
      Goodreads.reset_configuration
      
      client = Goodreads.new(:api_key => 'yfVhRfSgGgmiNRxsUE1Yg',:api_secret => ' JC79w77TvDyN7fj1LaPjZZ1Ia6ESiwzxZs8JaC358')
      
      search = client.search_books(title)

      if search.results.is_a? String
        ap("broke")
      elsif search.results.work.count > 1 and search.results.work[0].present?
        works = search.results.work
        b = client.book(works[0].best_book.id)
        
        if b.description.present?
          ba = b.to_a[1..-7]
          ba.delete_at(-9)

          bh = ba.to_h        
          update(bh) if bh["work"].nil?
        end

      end

    end

  # private

end
