require 'rails_helper'

RSpec.describe 'Search', type: :system do
  let!(:user) { create(:user) }
  let!(:post_1) do
    create(:post,
            name: '登別温泉',
            prefecture_id: '1', # 北海道
            city_id: '39') # 登別市
  end
  let!(:post_2) do
    create(:post,
            name: '七光台温泉',
            prefecture_id: '12', # 千葉県
            city_id: '608') # 野田市
  end
  let!(:post_3) do
    create(:post,
            name: '原鶴温泉',
            prefecture_id: '40', # 福岡県
            city_id: '1644') # 朝倉市
  end

  before '投稿検索ページへ移動する' do
    visit root_path
    page.driver.browser.switch_to.alert.accept
    click_link '思い出を探す'
    expect(current_path).to eq search_posts_path
  end

  describe '投稿を検索する', js: true  do
    it '名前で検索できる' do
      # 登別温泉で検索する
      fill_in '温泉の名前は？',	with: '登別温泉'
      click_button '検索する'
      expect(page).to have_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_2.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_3.id}"

      # 七光台温泉で検索する
      fill_in '温泉の名前は？',	with: '七光台温泉'
      click_button '検索する'
      expect(page).to have_link nil, href: "/posts/#{post_2.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_3.id}"

      # 原鶴温泉で検索する
      fill_in '温泉の名前は？',	with: '原鶴温泉'
      click_button '検索する'
      expect(page).to have_link nil, href: "/posts/#{post_3.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_2.id}"
    end

    it '都道府県で検索できる' do
      # 北海道で検索する
      select '北海道', from: '都道府県は？'
      click_button '検索する'
      expect(page).to have_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_2.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_3.id}"

      # 千葉県で検索する
      select '千葉県', from: '都道府県は？'
      click_button '検索する'
      expect(page).to have_link nil, href: "/posts/#{post_2.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_3.id}"

      # 福岡県で検索する
      select '福岡県', from: '都道府県は？'
      click_button '検索する'
      expect(page).to have_link nil, href: "/posts/#{post_3.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_2.id}"
    end

    it '都道府県 + 市区町村で検索できる' do
      # 北海道 + 登別市で検索する
      select '北海道', from: '都道府県は？'
      select '登別市', from: 'post[city_id]'
      click_button '検索する'
      expect(page).to have_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_2.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_3.id}"

      # 千葉県 + 野田市で検索する
      select '千葉県', from: '都道府県は？'
      select '野田市', from: 'post[city_id]'
      click_button '検索する'
      expect(page).to have_link nil, href: "/posts/#{post_2.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_3.id}"

      # 福岡県 + 朝倉市で検索する
      select '福岡県', from: '都道府県は？'
      select '朝倉市', from: 'post[city_id]'
      click_button '検索する'
      expect(page).to have_link nil, href: "/posts/#{post_3.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_2.id}"
    end

    it '投稿されていない名前は検索できない' do
      # 小湊温泉で検索する
      fill_in '温泉の名前は？',	with: '小湊温泉'
      click_button '検索する'
      expect(page).to have_no_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_2.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_3.id}"
    end

    it '投稿されていない都道府県は検索できない' do
      # 広島県で検索する
      select '広島県', from: '都道府県は？'
      click_button '検索する'
      expect(page).to have_no_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_2.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_3.id}"
    end

    it '投稿されていない市区町村は検索できない' do
      # 広島市中区で検索する
      select '広島県', from: '都道府県は？'
      select '広島市中区', from: 'post[city_id]'
      click_button '検索する'
      expect(page).to have_no_link nil, href: "/posts/#{post_1.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_2.id}"
      expect(page).to have_no_link nil, href: "/posts/#{post_3.id}"
    end
  end
end