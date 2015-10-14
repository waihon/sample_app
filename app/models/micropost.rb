class Micropost < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  # Support for calling default_scope without a block is removed.
  #default_scope order: "microposts.created_at DESC"
  default_scope { order("microposts.created_at DESC") }
end
