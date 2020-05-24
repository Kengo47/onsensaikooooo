class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.page.all
    @user_liked_posts = @user.liked_posts.all
    # @user_posts = @user.posts.page(params[:page]).per(6)
    # @user_liked_posts = @user.liked_posts.page(params[:page]).per(6)
    @following_users = @user.following.all
    @followers_users = @user.followers.all
  end
end
