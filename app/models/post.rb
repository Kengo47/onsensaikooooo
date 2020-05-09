# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)
#  picture    :string(255)
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id                 (user_id)
#  index_posts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :title, presence: true, length: { maximum: 20 }
  validates :body, length: { maximum: 140 }
end
