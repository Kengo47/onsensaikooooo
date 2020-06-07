require 'rails_helper'

RSpec.describe 'Post', type: :system, js: true do
  let!(:user) { create(:user) }
  before 'ログイン' do
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  it '新規投稿ページの要素が正しく表示される' do
    visit new_post_path

    expect(page).to have_content '温泉と思い出を追加'
    expect(page).to have_field 'post[name]'
    expect(page).to have_select 'post[prefecture_id]'
    expect(page).to have_select 'post[city_id]'
    expect(page).to have_field 'post[body]'
    expect(page).to have_field 'file', visible: false
    expect(page).to have_button '追加！'
  end

  it '新規投稿、編集、削除が可能' do
    visit new_post_path

    # 新規投稿する
    fill_in '温泉の名前は？（20文字以内）', with: 'テスト温泉'
    select '千葉県', from: '都道府県'
    select '野田市', from: '市区町村'
    attach_file 'post[picture]', "#{Rails.root}/spec/fixtures/test.png", make_visible: true
    fill_in 'どんな思い出？（140文字以内）', with: 'テスト温泉についてです。'
    click_button '追加！'

    post = Post.first
    aggregate_failures do
      expect(post.name).to eq 'テスト温泉'
      expect(post.prefecture.name).to eq '千葉県'
      expect(post.city.name).to eq '野田市'
      expect(current_path).to eq post_path(post)
      expect(page).to have_content '投稿しました！'
    end

    # 投稿を編集する
    click_link '編集'
    expect(current_path). to eq edit_post_path(post)
    expect(page).to have_content '温泉と思い出の編集'

    fill_in '温泉の名前は？（20文字以内）', with: 'テスト温泉2'
    select '埼玉県', from: '都道府県'
    select '春日部市', from: '市区町村'
    click_button '更新！'

    post.reload
    aggregate_failures do
      expect(post.name).to eq 'テスト温泉2'
      expect(post.prefecture.name).to eq '埼玉県'
      expect(post.city.name).to eq '春日部市'
      expect(current_path).to eq post_path(post)
      expect(page).to have_content '更新しました！'
    end

    # 投稿を削除する
    click_link '削除'
    expect {
      page.accept_confirm '本当に削除して良いですか？'
      expect(page).to have_content '投稿削除しました！'
    }.to change(Post, :count).by(-1)
    expect(current_path).to eq root_path
    expect(Post.where(id: post.id)).to be_empty
  end

  it '他人の投稿の編集、削除はできないこと' do
    other_user = create(:user)
    other_post = create(:post, user: other_user)

    visit post_path(other_post)
    expect(current_path).to eq post_path(other_post)
    expect(page).to_not have_content '編集'
    expect(page).to_not have_content '削除'

    # 他人の編集はできない
    visit edit_post_path(other_post)
    expect(current_path).to eq root_path
  end
end