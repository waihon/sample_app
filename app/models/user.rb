# Reviewed
class User < ActiveRecord::Base
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", 
                           class_name: "Relationship",
                           dependent: :destroy
  # The source ":followed" refer to that in "relationship" model
  has_many :followed_users, through: :relationships, source: :followed
  #has_many :following, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower                                 

  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[\w+\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  #validates :password, presence: true, length: { minimum: 6 }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def following?(other_user)
    self.relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    self.relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    # This is only a proto-feed
    # To prevent SQL injection, don't use #{}, use ? instead.
    #Micropost.where("user_id = #{id}")
    #Micropost.where("user_id = ?", id)
    # TODO
    Micropost.from_users_followed_by(self)
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
