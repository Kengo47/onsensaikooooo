require 'rails_helper'

RSpec.describe 'Login', type: :system do
  let!(:user) { create(:user) }

  it 'ログインページの要素検証' do
    visit new_user_session_path
    expect(page).to have_content 'ログイン'
    expect(page).to have_field 'メールアドレス'
    expect(page).to have_field 'パスワード'
    expect(page).to have_button 'ログイン'
    expect(page).to have_button 'かんたんログイン'
    expect(page).to have_link '新規登録'
  end

  describe '通常ユーザーのログイン' do
    it '各入力欄に適切な値が入力されていないログインを許可しない' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: 'user@invalid'
      fill_in 'パスワード', with: 'foo'
      click_button 'ログイン'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
    end

    it '正しいメールアドレスでないとログインを許可しない' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: 'user@invalid'
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
    end

    it '正しいパスワードでないとログインを許可しない' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'foo'
      click_button 'ログイン'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
    end

    it 'メール認証の完了していないユーザーのログインを許可しない' do
      unconfirmed_user = create(:user, :unconfirmed_user)

      visit new_user_session_path
      fill_in 'メールアドレス', with: unconfirmed_user.email
      fill_in 'パスワード', with: unconfirmed_user.password
      click_button 'ログイン'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'メールアドレスの本人確認が必要です。'
    end

    it 'ログイン成功' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      expect(current_path).to eq root_path
      expect(page).to have_content 'ログインしました。'
    end
  end

  describe 'かんたんログイン' do
    it 'ゲストユーザーのログイン成功' do
      guest = create(:user, :guest)

      visit new_user_session_path
      click_button 'かんたんログイン'
      expect(current_path).to eq root_path
      expect(page).to have_content 'ログインしました。'
      expect(page).to have_content 'Guest Userさんでログイン中'
    end
  end

  describe '管理者ユーザーのログイン' do
    it '管理者ユーザーのログイン成功' do
      admin = create(:user, :admin)

      visit new_user_session_path
      fill_in 'メールアドレス', with: admin.email
      fill_in 'パスワード', with: admin.password
      click_button 'ログイン'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Admin Userさんでログイン中'
      expect(page).to have_link '全てのユーザー'
    end
  end

  describe '未ログイン状態のリダイレクト' do
    it 'ユーザー詳細ページにアクセスできない' do
      visit user_path(user)
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end

    it '新規投稿ページにアクセスできない' do
      visit new_post_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end

    it 'ユーザー検索ページにアクセスできない' do
      visit users_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end
  end

  describe 'ログアウト' do
    it 'ログアウトが可能である' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'

      click_link "#{user.name}さんでログイン中"
      click_link 'ログアウト'
      expect(current_path).to eq root_path
      expect(page).to have_content 'ログアウトしました。'
    end
  end
end