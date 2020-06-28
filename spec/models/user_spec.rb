# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  avatar                 :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)      not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
  end

  it 'ファクトリが有効である' do
    expect(build(:user)).to be_valid
  end

  it 'ユーザー登録には名前、メール、パスワードが必要' do
    user = User.new(
      name: 'Test User',
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    expect(user).to be_valid
  end

  describe '存在性の検証' do
    it 'nameが無いと無効' do
      @user.name = ''
      expect(@user).to_not be_valid
    end

    it 'emailが無いと無効' do
      @user.email = ''
      expect(@user).to_not be_valid
    end

    it 'passwordが無いと無効' do
      @user.password = @user.password_confirmation = ' ' * 6
      expect(@user).to_not be_valid
    end

    it 'passwordとpassword_confirmationが一致しないと無効' do
      @user.password_confirmation = 'wordpass'
      expect(@user).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it 'nameが15文字以上は無効' do
      @user.name = 'a' * 16
      expect(@user).to_not be_valid
    end

    it 'passwordが6文字以内は無効' do
      @user.password = 'a' * 5
      expect(@user).to_not be_valid
    end

    it 'password_confirmationが6文字以内は無効' do
      @user.password = 'a' * 5
      expect(@user).to_not be_valid
    end
  end

  describe '一意性の検証' do
    it 'nameが一意でないと無効' do
      create(:user, name: 'TestUser')
      user2 = build(:user, name: 'TestUser')
      expect(user2).to_not be_valid
    end

    it 'emailが一意でないと無効' do
      create(:user, email: 'test@example.com')
      user2 = build(:user, email: 'test@example.com')
      expect(user2).to_not be_valid
    end

    it 'メールアドレスはすべて小文字で保存される' do
      @user.email = 'TEST@EXAMPLE.COM'
      @user.save!
      expect(@user.reload.email).to eq 'test@example.com'
    end

    it 'メールアドレスは大文字小文字を区別せず扱う' do
      create(:user, email: 'test@example.com')
      duplicate_user = build(:user, email: 'TEST@EXAMPLE.COM')
      expect(duplicate_user).to_not be_valid
    end
  end

  describe 'フォローメソッドの検証' do
    before do
      @konoka = create(:user)
      @hina = create(:user)
    end

    it 'ユーザーをフォロー/フォロー解除できること' do
      expect(@konoka.following?(@hina)).to be_falsey
      @konoka.follow(@hina)
      expect(@konoka.following?(@hina)).to be_truthy
      @konoka.unfollow(@hina)
      expect(@konoka.following?(@hina)).to be_falsey
    end

    it 'フォロー中のユーザーが削除されると、フォローが解除される' do
      @konoka.follow(@hina)
      expect(@konoka.following?(@hina)).to be_truthy
      @hina.destroy
      expect(@konoka.following?(@hina)).to be_falsey
    end

    it 'フォローされているユーザーが削除されると、フォローされている状態が解除される' do
      @konoka.follow(@hina)
      expect(@hina.followers.include?(@konoka)).to be_truthy
      @konoka.destroy
      expect(@hina.followers.include?(@konoka)).to be_falsey
    end
  end

  describe '関連性の検証' do
    it 'ユーザーを削除すると、関連する投稿も削除される' do
      post = create(:post)
      expect { post.user.destroy }.to change { Post.count }.by(-1)
    end

    it 'ユーザーを削除すると、関連するコメントも削除される' do
      comment = create(:comment)
      expect { comment.user.destroy }.to change { Comment.count }.by(-1)
    end

    it 'ユーザーを削除すると、関連するいいねも削除される' do
      user = create(:user)
      post = create(:post)
      user.like(post)
      expect(post.likes.count).to eq 1
      expect { user.destroy }.to change { user.liked_posts.count }.by(-1)
    end

    it 'ユーザーを削除すると、フォローしているユーザーとの関係も削除される' do
      user = create(:user)
      other_user = create(:user)
      user.follow(other_user)
      expect(other_user.followers.include?(user)).to be_truthy
      expect { user.destroy }.to change { other_user.followers.count }.by(-1)
    end

    it 'ユーザーを削除すると、フォロワーのユーザーとの関係も削除される' do
      user = create(:user)
      other_user = create(:user)
      other_user.follow(user)
      expect(other_user.following?(user)).to be_truthy
      expect { user.destroy }.to change { other_user.following.count }.by(-1)
    end
  end
end
