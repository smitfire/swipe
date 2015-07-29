class Vote < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  # SCOPES
  scope :liked, -> { where( liked: true ) }
  # scope :matched, -> { includes(:book).where( liked: true, book: { user_id: } ) }

  # Validations
  validates :user_id, :uniqueness => { :scope => :book_id }
  validates :book_id, :uniqueness => { :scope => :user_id }
  
  validate :cant_vote_on_own_book, if: "user_id.present?"


  # def match?
  #   if liked == true and book.owner.liked_users.exists?(user_id: user.id)
  #     [ book ]
  #   end
  #   # user.received_likes
  # end

  private
    def cant_vote_on_own_book
      errors.add(:user_id, 'You cant vote on your own book idiot.') if self.user_id == book.owner.id
    end
end
