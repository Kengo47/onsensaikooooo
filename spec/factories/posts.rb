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
FactoryBot.define do
  factory :post do
    name { "七光台温泉" }
    body { "地元の温泉で、最高です。" }
    prefecture_id { 1 }
    city_id { 1 }
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    association :user
  end
end
