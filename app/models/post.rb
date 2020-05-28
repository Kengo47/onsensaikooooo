# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  body          :text(65535)
#  name          :string(255)      not null
#  picture       :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  city_id       :bigint
#  prefecture_id :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_posts_on_city_id                 (city_id)
#  index_posts_on_prefecture_id           (prefecture_id)
#  index_posts_on_user_id                 (user_id)
#  index_posts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture
  belongs_to :city
  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 140 }
  validates :picture, presence: true

end
