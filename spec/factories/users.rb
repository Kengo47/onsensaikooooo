# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  avatar                 :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)      not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "TserUser#{n}" }
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { 'password' }
    confirmed_at { Time.zone.today }

    trait :guest do
      name     { 'Guest User' }
      email    { 'guest@example.com' }
      password { '123456' }
    end

    trait :admin do
      name     { 'Admin User' }
      email    { 'admin@example.com' }
      password { '123456' }
      admin    { true }
    end

    trait :unconfirmed_user do
      name  { 'メール未認証' }
      email { 'unconfirmed@user.com' }
      password { 'password' }
      confirmed_at { nil }
    end
  end
end
