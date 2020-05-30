class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.all
    @user_liked_posts = @user.liked_posts.all
    @following = @user.following.all
    @followers = @user.followers.all
  end
end
