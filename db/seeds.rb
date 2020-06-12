# CSVファイルを使用することを明示
require 'csv'

# 使用するデータ（CSVファイルの列）を指定
CSVROW_PREFNAME = 1
CSVROW_CITYNAME = 2

# CSVファイルを読み込み、DB（テーブル）へ保存
CSV.foreach('db/csv/KEN_CITY.CSV', encoding: "Shift_JIS:UTF-8") do |row|
  prefecture_name = row[CSVROW_PREFNAME]
  city_name = row[CSVROW_CITYNAME]
  prefecture = Prefecture.find_or_create_by(name: prefecture_name)
  City.find_or_create_by(name: city_name, prefecture_id: prefecture.id)
end

# サンプルユーザーの作成
5.times do |n|
  User.create!(
    email: "test#{n + 1}@test.com",
    name: "サンプルユーザー#{n + 1}",
    password: 'password',
    confirmed_at: Time.now,
    avatar: open("#{Rails.root}/db/fixtures/avatar/avatar-test#{n + 1}.png")
  )
end

# かんたんログイン用ユーザーの作成
User.create!(name: "Guest User",
              email: "guest@example.com",
              password: "123456",
              confirmed_at: Time.now)

# 管理ユーザーの作成
User.create!(name: "Admin User",
  email: "admin@example.com",
  password: "123456",
  confirmed_at: Time.now,
  avatar: open("#{Rails.root}/db/fixtures/avatar/avatar-test1.png"),
  admin: true)

# サンプル投稿の作成
user1 = User.first
user2 = User.second
user3 = User.third
user4 = User.fourth
user5 = User.fifth

user1.posts.create!(name: "登別温泉",
                    prefecture_id: 1,
                    city_id: 39,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/1.jpg"))
user1.posts.create!(name: "酸ヶ湯温泉",
                    prefecture_id: 2,
                    city_id: 189,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/2.jpg"))
user1.posts.create!(name: "花巻温泉",
                    prefecture_id: 3,
                    city_id: 232,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/3.jpg"))
user1.posts.create!(name: "鳴子温泉",
                    prefecture_id: 4,
                    city_id: 278,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/4.jpg"))
user1.posts.create!(name: "男鹿温泉",
                    prefecture_id: 5,
                    city_id: 305,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/5.jpg"))
user1.posts.create!(name: "蔵王温泉",
                    prefecture_id: 6,
                    city_id: 326,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/6.jpg"))
user1.posts.create!(name: "猪苗代温泉",
                    prefecture_id: 7,
                    city_id: 387,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/7.jpg"))
user1.posts.create!(name: "袋田温泉",
                    prefecture_id: 8,
                    city_id: 456,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/8.jpg"))
user1.posts.create!(name: "鬼怒川温泉",
                    prefecture_id: 9,
                    city_id: 469,
                    body: "前に旅行に行ったことがあります。",
                    picture: open("#{Rails.root}/db/fixtures/posts/9.jpg"))
user1.posts.create!(name: "草津温泉",
                    prefecture_id: 10,
                    city_id: 511,
                    body: "以前車で行きましたが、結構遠くてしんどかったです。",
                    picture: open("#{Rails.root}/db/fixtures/posts/10.jpg"))
user2.posts.create!(name: "春日部温泉湯楽の里",
                    prefecture_id: 11,
                    city_id: 544,
                    body: "地元近くの温泉で、よく通っています。",
                    picture: open("#{Rails.root}/db/fixtures/posts/11.jpg"))
user2.posts.create!(name: "七光台温泉",
                    prefecture_id: 12,
                    city_id: 608,
                    body: "地元にある温泉で、しょっちゅう通っています。",
                    picture: open("#{Rails.root}/db/fixtures/posts/12.jpg"))
user2.posts.create!(name: "お台場大江戸温泉物語",
                    prefecture_id: 13,
                    city_id: 662,
                    body: "いつか彼女と行ってみたいものです。",
                    picture: open("#{Rails.root}/db/fixtures/posts/13.jpg"))
user2.posts.create!(name: "箱根湯本温泉",
                    prefecture_id: 14,
                    city_id: 770,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/14.jpg"))
user2.posts.create!(name: "六日町温泉",
                    prefecture_id: 15,
                    city_id: 800,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/15.jpg"))
user2.posts.create!(name: "金太郎温泉",
                    prefecture_id: 16,
                    city_id: 814,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/16.jpg"))
user2.posts.create!(name: "和倉温泉",
                    prefecture_id: 17,
                    city_id: 828,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/17.jpg"))
user2.posts.create!(name: "東尋坊温泉",
                    prefecture_id: 18,
                    city_id: 854,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/18.jpg"))
user2.posts.create!(name: "甲府温泉",
                    prefecture_id: 19,
                    city_id: 863,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/19.jpg"))
user2.posts.create!(name: "野沢温泉",
                    prefecture_id: 20,
                    city_id: 962,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/20.jpg"))
user3.posts.create!(name: "下呂温泉",
                    prefecture_id: 21,
                    city_id: 986,
                    body: "有名ですよね。行ってみたいです。",
                    picture: open("#{Rails.root}/db/fixtures/posts/21.jpg"))
user3.posts.create!(name: "修善寺温泉",
                    prefecture_id: 22,
                    city_id: 1035,
                    body: "以前旅行で行きました。最高でしたね。",
                    picture: open("#{Rails.root}/db/fixtures/posts/22.jpg"))
user3.posts.create!(name: "南知多湯本温泉郷",
                    prefecture_id: 23,
                    city_id: 1114,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/23.jpg"))
user3.posts.create!(name: "湯の山温泉",
                    prefecture_id: 24,
                    city_id: 1137,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/24.jpg"))
user3.posts.create!(name: "おごと温泉",
                    prefecture_id: 25,
                    city_id: 1150,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/25.jpg"))
user3.posts.create!(name: "天橋立温泉",
                    prefecture_id: 26,
                    city_id: 1184,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/26.jpg"))
user3.posts.create!(name: "犬鳴山温泉",
                    prefecture_id: 27,
                    city_id: 1247,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/27.jpg"))
user3.posts.create!(name: "有馬温泉",
                    prefecture_id: 28,
                    city_id: 1283,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/28.jpg"))
user3.posts.create!(name: "吉野温泉",
                    prefecture_id: 29,
                    city_id: 1354,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/29.jpg"))
user3.posts.create!(name: "白浜温泉",
                    prefecture_id: 30,
                    city_id: 1387,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/30.jpg"))
user4.posts.create!(name: "鳥取温泉",
                    prefecture_id: 31,
                    city_id: 1395,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/31.jpg"))
user4.posts.create!(name: "出雲湯村温泉",
                    prefecture_id: 32,
                    city_id: 1416,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/32.jpg"))
user4.posts.create!(name: "瀬戸大橋温泉",
                    prefecture_id: 33,
                    city_id: 1437,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/33.jpg"))
user4.posts.create!(name: "宮浜温泉",
                    prefecture_id: 34,
                    city_id: 1481,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/34.jpg"))
user4.posts.create!(name: "長門湯本温泉",
                    prefecture_id: 35,
                    city_id: 1501,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/35.jpg"))
user4.posts.create!(name: "鳴門温泉",
                    prefecture_id: 36,
                    city_id: 1513,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/36.jpg"))
user4.posts.create!(name: "こんぴら温泉郷",
                    prefecture_id: 37,
                    city_id: 1550,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/37.jpg"))
user4.posts.create!(name: "今治温泉",
                    prefecture_id: 38,
                    city_id: 1554,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/38.jpg"))
user4.posts.create!(name: "黒潮温泉龍馬の湯",
                    prefecture_id: 39,
                    city_id: 1582,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/39.jpg"))
user4.posts.create!(name: "原鶴温泉",
                    prefecture_id: 40,
                    city_id: 1644,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/40.jpg"))
user5.posts.create!(name: "熊の川温泉",
                    prefecture_id: 41,
                    city_id: 1679,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/41.jpg"))
user5.posts.create!(name: "雲仙温泉",
                    prefecture_id: 42,
                    city_id: 1710,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/42.jpg"))
user5.posts.create!(name: "地獄温泉",
                    prefecture_id: 43,
                    city_id: 1750,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/43.jpg"))
user5.posts.create!(name: "別府温泉",
                    prefecture_id: 44,
                    city_id: 1770,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/44.jpg"))
user5.posts.create!(name: "青島温泉",
                    prefecture_id: 45,
                    city_id: 1787,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/45.jpg"))
user5.posts.create!(name: "指宿温泉",
                    prefecture_id: 46,
                    city_id: 1818,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/46.jpg"))
user5.posts.create!(name: "那覇天然温泉",
                    prefecture_id: 47,
                    city_id: 1856,
                    body: "サンプル投稿です",
                    picture: open("#{Rails.root}/db/fixtures/posts/47.jpg"))

# お気に入りデータ作成
users = User.order(:id).take(7)
posts = Post.order(:id).take(6)
users.each do |user|
  posts.each do |post|
    user.like(post) unless user.id == post.user_id
  end
end