require 'rails_helper'

RSpec.describe 'Relationship', type: :system, js: true do
  let!(:konoka) { create(:user, name: 'konoka') }
  let!(:nao) { create(:user, name: 'nao') }
  let!(:nao_post) { create(:post, user: nao) }

  it 'ユーザーをフォロー/フォロー解除できる' do
    # konokaがログインする
    visit new_user_session_path
    fill_in 'メールアドレス', with: konoka.email
    fill_in 'パスワード', with: konoka.password
    click_button 'ログイン'
    page.driver.browser.switch_to.alert.accept

    # naoのページは移動する
    click_link '思い出を探す'
    expect(current_path).to eq search_posts_path
    expect(page).to have_link nil, href: "/posts/#{nao_post.id}"
    click_link nil, href: "/posts/#{nao_post.id}"
    expect(current_path).to eq "/posts/#{nao_post.id}"
    click_link 'nao'
    expect(current_path).to eq user_path(nao)

    # naoをkonokaがフォローする
    expect(page).to have_content 'nao'
    expect(page).to have_content '0 フォロー'
    expect(page).to have_content '0 フォロワー'
    expect(page).to have_button 'フォローする'
    expect do
      click_button 'フォローする'
      expect(page).to have_content '1 フォロワー'
      expect(page).to have_no_button 'フォローする'
      expect(page).to have_button 'フォロー解除'
    end.to change(konoka.following, :count).by(1) &
           change(nao.followers, :count).by(1)

    # konokaのページに移動する
    click_link 'konokaさんでログイン中'
    click_link 'マイページ'
    expect(current_path).to eq user_path(konoka)
    expect(page).to have_content 'konoka'
    expect(page).to have_content '1 フォロー'
    click_link nil, href: '#tab3'
    expect(page).to have_content 'nao'

    # naoのページに移動する
    click_link nil, href: "/users/#{nao.id}"
    expect(current_path).to eq user_path(nao)
    expect(page).to have_button 'フォロー解除'

    # naoをフォロー解除する
    expect do
      click_button 'フォロー解除'
      expect(page).to have_content '0 フォロワー'
      expect(page).to have_button 'フォローする'
      expect(page).to have_no_button 'フォロー解除'
    end.to change(konoka.following, :count).by(-1) &
           change(nao.followers, :count).by(-1)

    # konokaのページに移動する
    click_link 'konokaさんでログイン中'
    click_link 'マイページ'
    expect(current_path).to eq user_path(konoka)
    expect(page).to have_content '0 フォロー'
    click_link nil, href: '#tab3'
    expect(page).to have_content 'フォローしてみましょう！'
  end
end
