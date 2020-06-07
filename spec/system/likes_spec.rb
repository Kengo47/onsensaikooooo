require 'rails_helper'

RSpec.describe 'Like', type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:post) { create(:post) }

  it '投稿をお気に入り、解除が可能' do
    # ログインする
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'

    # 投稿詳細へ移動する
    page.driver.browser.switch_to.alert.accept
    click_link '思い出を探す'
    expect(current_path).to eq search_posts_path
    expect(page).to have_link nil, href: "/posts/#{post.id}"
    click_link nil, href: "/posts/#{post.id}"
    expect(current_path).to eq "/posts/#{post.id}"

    # 投稿をお気に入りをする
    expect(page).to have_content '0 件'
    expect do
      click_link 'お気に入り!'
      expect(page).to have_content '1 件'
    end.to change(post.likes, :count).by(1)

    # 投稿検索ページへ移動する
    click_link '思い出を探す'
    expect(current_path).to eq search_posts_path
    expect(page).to have_link nil, href: "/posts/#{post.id}"
    expect(page).to have_content '1 件'
    click_link nil, href: "/posts/#{post.id}"
    expect(current_path).to eq "/posts/#{post.id}"

    # 投稿のお気に入りを解除する
    expect(page).to have_content '1 件'
    expect do
      click_link 'お気に入り済'
      expect(page).to have_content '0 件'
    end.to change(post.likes, :count).by(-1)

    # 投稿検索ページへ移動する
    click_link '思い出を探す'
    expect(current_path).to eq search_posts_path
    expect(page).to have_link nil, href: "/posts/#{post.id}"
    expect(page).to have_content '0 件'
  end
end