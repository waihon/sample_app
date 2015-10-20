class Micropost < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  # Support for calling default_scope without a block is removed.
  #default_scope order: "microposts.created_at DESC"
  default_scope { order("microposts.created_at DESC") }

  def self.from_users_followed_by(user)
    # Option 1 - "join" doesn't work on PostgreSQL
    #followed_user_ids = user.followed_users.map(&:id).join(", ")
    # Option 2
    #followed_user_ids = user.followed_user_ids
    #where("user_id IN (?) OR user_id = ?", followed_user_ids, user.id)
    # Option 3
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          { user_id: user.id })
  end
end
