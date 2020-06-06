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
    fill_in 'メールアドレス', with: @user.email
    fill_in 'パスワード', with: @user.password

    click_button 'ログイン'
    expect(current_path).to eq root_path

    click_link "#{@user.name}さんでログイン中"
    click_link 'マイページ'
    expect(current_path).to eq user_path(@user)
    expect(page).to have_content "#{@user.name}"

    click_link 'アカウント編集'
    expect(current_path).to eq edit_user_registration_path
    expect(page).to have_content 'プロフィール編集'

    # attach_file 'user[avatar]', "#{Rails.root}/spec/fixtures/test.jpg", make_visible: true
    fill_in 'ニックネーム（１０文字以内）', with: 'ModifyUser'
    fill_in 'メールアドレス', with: 'modify@example.com'
    click_button '更新する'
    expect(current_path).to eq user_path(@user)
    expect(page).to have_content 'アカウント情報を変更しました。'
    @user.reload
    expect(page).to have_content "#{@user.name}"
  end
end