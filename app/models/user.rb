class User < ActiveRecord::Base
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  has_many :microposts, dependent: :destroy

  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[\w+\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  #validates :password, presence: true, length: { minimum: 6 }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    # This is only a proto-feed
    # To prevent SQL injection, don't use interpolation
    #Micropost.where("user_id = #{id}")
    Micropost.where("user_id = ?", id)
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
