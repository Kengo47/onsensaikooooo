# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  body          :text(65535)
#  latitude      :float(24)
#  longitude     :float(24)
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
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  geocoded_by :name
  after_validation :geocode
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 140 }, profanity_filter: true
  validates :picture, presence: true

  def create_notification_like(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(['visitor_id = ? and visited_id = ? and post_id = ? and action = ?', current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    return if temp.present?

    notification = current_user.active_notifications.new(
      post_id: id,
      visited_id: user_id,
      action: 'like'
    )
    # 自分の投稿に対するいいねの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_comment(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment(current_user, comment_id, user_id) if temp_id.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  # 検索機能のスコープ
  scope :search, lambda { |search_params|
    return if search_params.blank?

    name_like(search_params[:name])
      .prefecture_id_is(search_params[:prefecture_id])
      .city_id_is(search_params[:city_id])
  }
  scope :name_like, lambda { |name|
                      where('name LIKE ?', "%#{name}%") if name.present?
                    }
  scope :prefecture_id_is, lambda { |prefecture_id|
                             where(prefecture_id: prefecture_id) if prefecture_id.present?
                           }
  scope :city_id_is, lambda { |city_id|
                       where(city_id: city_id) if city_id.present?
                     }
end
