# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  comment    :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }

  it 'ファクトリが有効である' do
    expect(comment).to be_valid
  end

  it 'コメントにはコメント, ユーザー, ポストが必要' do
    user = create(:user)
    post = create(:post)
    comment = Comment.new(
      comment: 'コメント',
      user: user,
      post: post
    )
    expect(comment).to be_valid
  end

  describe '存在性の検証' do
    it 'コメントが無いと無効' do
      comment.comment = ' '
      expect(comment).to_not be_valid
    end

    it 'ユーザーが無いと無効' do
      comment.user = nil
      expect(comment).to_not be_valid
    end

    it 'ポストが無いと無効' do
      comment.post = nil
      expect(comment).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it 'コメントが50文字以上は無効' do
      comment.comment = 'a' * 51
      expect(comment).to_not be_valid
    end
  end

  describe 'その他' do
    it 'コメントが新しい順に並んでいること' do
      post = create(:post)
      create(:comment, post: post, created_at: 5.days.ago)
      most_recent = create(:comment, post: post, created_at: Time.zone.now)
      create(:comment, post: post, created_at: 5.minutes.ago)
      expect(most_recent).to eq Comment.first
    end
  end
end
