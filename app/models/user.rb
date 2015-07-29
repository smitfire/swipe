class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100" }, :default_url => "/images/p.jpg"
  validates_attachment_content_type :avatar, :content_type => /\Aimage/
  # validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/, /jpg\Z/, /JPG\Z/]
  
  has_many :votes, -> { includes :book }, dependent: :destroy
  
  has_many :owned_books, ->{ uniq }, class_name: "Book", dependent: :destroy, inverse_of: :owner

  has_many :voted_books, -> { uniq }, through: :votes, source: :book

  has_many :given_likes, -> { where(liked: true) }, class_name: "Vote"

  has_many :ungiven_likes, -> { where(liked: false) }, class_name: "Vote"

  has_many :liked_books, -> { uniq }, through: :given_likes, source: :book

  has_many :disliked_books, -> { uniq }, through: :ungiven_likes, source: :book

  has_many :received_votes, through: :owned_books, source: :votes

  has_many :received_likes, ->{ where(liked: true) }, through: :owned_books, source: :votes

  has_many :books_liked, through: :received_likes, source: :book

  has_many :likers, -> { uniq }, through: :received_likes, source: :user

  has_many :liked_users, -> { uniq }, through: :liked_books, source: :owner

  # GEOCODER
  # geocoded_by :address_str   # can also be an IP address
  # geocoded_by :full_address   # can also be an IP address
  # after_validation :geocode, unless: "full_address.nil?"

  # geocoded_by :ip_address
  # after_validation :geocode, unless: "ip_address.nil?"
  
  geocoded_by :ip_address,
    :latitude => :latitude, :longitude => :longitude
  after_validation :geocode, unless: "latitude != nil"

  # reverse_geocoded_by :latitude, :longitude
  # after_validation :geocode, :reverse_geocode


  # after_validation :reverse_geocode, :if => :has_coordinates
  # after_validation :geocode, :if => :has_location, :unless => :has_coordinates
  
  # SCOPES
  scope :people_in_range, -> (user) { where("id != ? and ", user.id ).near( [ user.latitude, user.longitude ], user.range ) }
  scope :all_likers, -> { joins(:votes).where('votes.liked = ?', true) }
  scope :all_voters, -> { joins(:votes).where('votes.user_id != ?', nil ) }

  # Validations

  # def address_str
  #     [street, city, state, country].compact.join(', ')
  # end

  def matches
    liked_books.where(user_id: likers.ids)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
    end
  end

  def bookstack
    if geocoded?
      bkids = owned_books.ids+voted_books.ids
      usrids = nearbys(range).flat_map{|usr| usr.id}
      Book.where("user_id in (?) AND id not in (?)", usrids, bkids)
    else
      puts "not geocoded"
    end
  end


  private
    def self.ransackable_scopes(auth_object = nil)
      %i(active hired_since all_likers)
    end

end