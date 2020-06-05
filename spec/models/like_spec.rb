# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_post_id  (post_id)
#  index_likes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like) { create(:like) }

  it 'ファクトリが有効である' do
    expect(like).to be_valid
  end

  it 'いいねにはユーザー, ポストが必要' do
    user = create(:user)
    post = create(:post)
    like = Like.new(
      user: user,
      post: post
    )
    expect(like).to be_valid
  end

  describe '存在性の検証' do
    it 'ユーザーが無いと無効' do
      like.user = nil
      expect(like).to_not be_valid
    end

    it 'ポストが無いと無効' do
      like.post = nil
      expect(like).to_not be_valid
    end
  end
end
