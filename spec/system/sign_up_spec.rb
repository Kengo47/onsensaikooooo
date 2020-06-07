require 'rails_helper'

RSpec.describe 'Sing_up', type: :system do
  let(:user) { create(:user) }

  it '新規登録ページの要素検証' do
    visit signup_path
    expect(page).to have_content '会員情報の入力'
    expect(page).to have_field 'ニックネーム（１５文字以内）'
    expect(page).to have_field 'メールアドレス'
    expect(page).to have_field 'パスワード（６文字以上）'
    expect(page).to have_field '確認用パスワード'
    expect(page).to have_button '新規登録'
    expect(page).to have_link 'ログイン'
  end

  describe 'ユーザー新規登録' do
    it '各入力欄に適切な値が入力されていない新規登録を許可しない' do
      visit signup_path
      fill_in 'ニックネーム（１５文字以内）', with: ' '
      fill_in 'メールアドレス', with: 'user@invalid'
      fill_in 'パスワード（６文字以上）', with: 'foo'
      fill_in '確認用パスワード', with: 'bar'
      click_button '新規登録'
      expect(current_path).to eq signup_path
    end

    it '登録済みニックネーム' do
      visit signup_path
      fill_in 'ニックネーム（１５文字以内）', with: user.name
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'パスワード（６文字以上）', with: 'password'
      fill_in '確認用パスワード', with: 'password'
      click_button '新規登録'
      expect(current_path).to eq signup_path
      expect(page).to have_content 'ニックネームはすでに存在します'
    end

    it '登録済みメールアドレス' do
      visit signup_path
      fill_in 'ニックネーム（１５文字以内）', with: 'test-user'
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード（６文字以上）', with: 'password'
      fill_in '確認用パスワード', with: 'password'
      click_button '新規登録'
      expect(current_path).to eq signup_path
      expect(page).to have_content 'メールアドレスはすでに存在します'
    end

    it 'ユーザーを新規登録可能' do
      visit signup_path
      fill_in 'ニックネーム（１５文字以内）', with: 'test-user'
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'パスワード（６文字以上）', with: 'password'
      fill_in '確認用パスワード', with: 'password'
      expect do
        click_button '新規登録'
        expect(current_path).to eq root_path
        expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
      end.to change(User, :count).by(1)
    end
  end
end