require 'rails_helper'

RSpec.describe 'User', type: :system do
  before do
    @user = User.create(name: 'TestUser',
                        email: 'test@example.com',
                        password: 'password',
                        confirmed_at: Date.today)
  end

  it 'ユーザープロフィールを編集する' do
    visit new_user_session_path

    # ログインする
    fill_in 'メールアドレス', with: @user.name
    fill_in 'パスワード', with: @user.password

    click_button 'ログイン'
    expect(current_path).to eq root_path

    click_link "#{@user.name}さんでログイン中"
    click_link 'マイページ'
    expect(current_path).to eq user_path(@user)
    expect(page).to have_content "#{@user.name}"
  end
end