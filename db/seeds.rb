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

# かんたんログイン用ユーザーの作成
User.create!(name: "Guest User",
              email: "guest@example.com",
              password: "123456",
              confirmed_at: Time.now)

# サンプルユーザーの作成
5.times do |n|
  User.create!(
    email: "test#{n + 1}@test.com",
    name: "テスト太郎#{n + 1}",
    password: 'password',
    confirmed_at: Time.now
  )
end

# 管理ユーザーの作成
User.create!(name: "Admin User",
  email: "admin@example.com",
  password: "123456",
  confirmed_at: Time.now,
  avatar: open("#{Rails.root}/db/fixtures/1.jpg"),
  admin: true)

# サンプル投稿の作成
user = User.first
city = City.first
prefecture_id = city.prefecture_id
city_id = city.id

user.posts.create!(name: "七光台温泉",
        prefecture_id: prefecture_id,
        city_id: city_id,
        body: "サンプル投稿です",
        picture: open("#{Rails.root}/db/fixtures/1.jpg"))
user.posts.create!(name: "七光台温泉",
        prefecture_id: prefecture_id,
        city_id: city_id,
        body: "サンプル投稿です",
        picture: open("#{Rails.root}/db/fixtures/2.jpg"))
user.posts.create!(name: "七光台温泉",
        prefecture_id: prefecture_id,
        city_id: city_id,
        body: "サンプル投稿です",
        picture: open("#{Rails.root}/db/fixtures/3.jpg"))
user.posts.create!(name: "七光台温泉",
        prefecture_id: prefecture_id,
        city_id: city_id,
        body: "サンプル投稿です",
        picture: open("#{Rails.root}/db/fixtures/3.jpg"))