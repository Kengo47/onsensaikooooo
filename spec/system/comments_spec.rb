require 'rails_helper'

RSpec.describe 'Comment', type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:post) { create(:post) }

  it '投稿にコメントを追加、削除が可能' do
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

    # コメントを投稿する
    expect(page).to_not have_content '1 つのコメント'
    fill_in 'comment[comment]', with: 'テストコメントです！'
    find('.btn-default').click
    expect(page).to have_content 'テストコメントです！'
    expect(page).to have_content '1 つのコメント'

    # コメントを削除する
    find('.comment-destroy').click
    expect do
      page.accept_confirm 'コメントを削除してよろしいですか？'
      expect(page).to have_content 'まだコメントはありません...'
    end.to change(post.comments, :count).by(-1)
    expect(page).to_not have_content '1 つのコメント'
  end
end
