class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.all
    @following_users = @user.following.all
    @followers_users = @user.followers.all
  end
end
