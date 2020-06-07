require 'rails_helper'

RSpec.describe 'Destroy', type: :system do
  let!(:user) { create(:user) }

  describe '通常ユーザーのアカウント削除', js: true do
    before '通常ユーザーとしてログイン' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      page.driver.browser.switch_to.alert.accept
    end

    it '自分のアカウントを削除できる', js: true do
      click_link "#{user.name}さんでログイン中"
      click_link 'マイページ'
      click_link 'アカウント編集'
      expect(current_path).to eq edit_user_registration_path
      expect(page).to have_content 'アカウントの削除'

      click_link '削除する'
      expect {
        page.accept_confirm '本当に削除しますか？'
        expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
      }.to change(User, :count).by(-1)
    end

    it 'ユーザー検索ページにいけない' do
      visit users_path
      expect(current_path).to eq user_path(user)
    end
  end

  describe 'ゲストユーザーのアカウント削除' do
    it '自分のアカウントを削除できない' do
      guest = create(:user, :guest)

      visit new_user_session_path
      click_button 'かんたんログイン'

      click_link "#{guest.name}さんでログイン中"
      click_link 'マイページ'
      click_link 'アカウント編集'
      expect(current_path).to eq edit_user_registration_path

      expect(page).to_not have_content 'アカウントの削除'
      expect(page).to have_content 'ゲストユーザーはプロフィール画像のみ変更できます'
    end
  end

  describe '管理者ユーザーのアカウント削除' do
    before '管理者ユーザーとしてログイン' do
      @admin = create(:user, :admin)
      @guest = create(:user, :guest)

      visit new_user_session_path
      fill_in 'メールアドレス', with: @admin.email
      fill_in 'パスワード', with: @admin.password
      click_button 'ログイン'
    end

    it '自分のアカウントを削除できない' do
      click_link "#{@admin.name}さんでログイン中"
      click_link 'マイページ'

      expect(page).to_not have_content 'アカウントの編集'
      expect(page).to have_content '管理ユーザーです。'

      visit edit_user_registration_path
      expect(current_path).to eq root_path
    end

    it 'ユーザー検索ページからユーザーを削除できる', js: true do
      page.driver.browser.switch_to.alert.accept
      click_link '全てのユーザー'
      expect(current_path).to eq users_path

      # 通常ユーザーに「削除する」があること
      click_link '削除する', href: "/users/#{user.id}"
      expect {
        page.accept_confirm '本当に削除しますか？'
        expect(page).to have_content "「#{user.name}」を削除しました"
      }.to change(User, :count).by(-1)

      # ゲストユーザーに「削除する」がないこと
      expect(page).to_not have_link '削除する', href: "/users/#{@guest.id}"

      # 管理者ユーザーに「このユーザーを削除する」がないこと
      expect(page).to_not have_link '削除する', href: "/users/#{@admin.id}"
    end
  end
end