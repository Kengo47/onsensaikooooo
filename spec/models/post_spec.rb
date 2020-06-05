# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  body          :text(65535)
#  name          :string(255)      not null
#  picture       :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  city_id       :bigint
#  prefecture_id :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_posts_on_city_id                 (city_id)
#  index_posts_on_prefecture_id           (prefecture_id)
#  index_posts_on_user_id                 (user_id)
#  index_posts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }

  it 'ファクトリが有効である' do
    expect(post).to be_valid
  end

  it '投稿には名前、都道府県、市区町村、画像、思い出、ユーザーが必要' do
    user = create(:user)
    prefecture = create(:prefecture)
    city = create(:city)
    post = Post.new(
      name: '七光台温泉',
      prefecture: prefecture,
      city: city,
      picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')),
      body: '最高の地元の温泉',
      user: user
    )
    expect(post).to be_valid
  end

  describe '存在性の検証' do
    it '名前が無いと無効' do
      post.name = ' '
      expect(post).to_not be_valid
    end

    it '都道府県が無いと無効' do
      post.prefecture = nil
      expect(post).to_not be_valid
    end

    it '市区町村が無いと無効' do
      post.city = nil
      expect(post).to_not be_valid
    end

    it '画像が無いと無効' do
      post.picture = nil
      expect(post).to_not be_valid
    end

    it '思い出が無いと無効' do
      post.body = ' '
      expect(post).to_not be_valid
    end

    it 'ユーザーが無いと無効' do
      post.user = nil
      expect(post).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it '名前が20文字以上は無効' do
      post.name = "a" * 21
      expect(post).to_not be_valid
    end

    it '思い出が140文字以上は無効' do
      post.body = "a" * 141
      expect(post).to_not be_valid
    end
  end

  describe 'likeメソッドの検証' do
    it '投稿をいいね/いいね解除できる' do
      konoka = create(:user)
      expect(konoka.already_liked?(post)).to be_falsey
      konoka.like((post))
      expect(konoka.already_liked?(post)).to be_truthy
    end
  end

  describe '#search' do
    before do
      user = create(:user)
      prefecture = create(:prefecture, name: '千葉県')
      @city = create(:city, name: '千葉県', prefecture: prefecture)
      @post = create(:post,
                      user: user,
                      name: '七光台温泉',
                      prefecture: @city.prefecture,
                      city: @city)
      other_prefecture = create(:prefecture, name: '埼玉県')
      @other_city = create(:city, name: '春日部市', prefecture: other_prefecture)
      @other_post = create(:post,
                            user: user,
                            name: '春日部温泉　湯楽の里',
                            prefecture: @other_city.prefecture,
                            city: @other_city)
    end

    context "name: '七光台'で検索したとき、曖昧検索ができているか" do
      it '@postを返す' do
        expect(Post.search(name: '七光台')).to include(@post)
      end

      it '@other_postを返さない' do
        expect(Post.search(name: '七光台')).to_not include(@other_post)
      end
    end

    context "都道府県で検索したとき、一致検索できているか" do
      it '@postを返す' do
        expect(Post.search(prefecture_id: @city.prefecture.id)).to include(@post)
      end

      it '@other_postを返さない' do
        expect(Post.search(prefecture_id: @city.prefecture.id)).to_not include(@other_post)
      end
    end

    context "都道府県、市区町村で検索したとき、一致検索できているか" do
      it '@postを返す' do
        expect(Post.search(prefecture_id: @city.prefecture.id, city_id: @city.id)).to include(@post)
      end

      it '@other_postを返さない' do
        expect(Post.search(prefecture_id: @city.prefecture.id, city_id: @city.id)).to_not include(@other_post)
      end
    end
  end

  describe '関連性の検証' do
    it '投稿を削除すると、関連するコメントも削除される' do
      comment = create(:comment, post: post)
      expect { comment.post.destroy }.to change { Comment.count }.by(-1)
    end

    it '投稿を削除すると、関連するいいねも削除される' do
      user = create(:user)
      liked_post = create(:post, user: user)
      user.like(liked_post)
      expect { liked_post.destroy }.to change { Like.count }.by(-1)
    end
  end

  describe 'その他' do
    it '投稿が新しい順に並んでいること' do
      create(:post, created_at: 5.days.ago)
      most_recent = create(:post, created_at: Time.zone.now)
      create(:post, created_at: 5.minutes.ago)
      expect(most_recent).to eq Post.first
    end

    it '人気投稿ページ：投いいねが多い順に投稿がに並んでいること' do
      pending "あとで追加する"
        expect(most_liked).to eq Post.first
    end
  end
end
