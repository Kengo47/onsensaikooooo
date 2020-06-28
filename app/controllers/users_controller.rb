class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index destroy]
  before_action :admin_user, only: %i[index destroy]
  before_action :set_target_user, only: %i[show destroy]

  def index
    @search_params = user_search_params
    @users = User.search(@search_params).page(params[:page]).per(12)
  end

  def show
    @user_posts = @user.posts.all.includes(:prefecture, :city)
    @user_liked_posts = @user.liked_posts.all
    @following = @user.following.all
    @followers = @user.followers.all
  end

  def destroy
    @user.destroy
    flash[:notice] = "「#{@user.name}」を削除しました"
    redirect_to users_url
  end

  private

  def admin_user
    redirect_back(fallback_location: user_url(current_user)) unless current_user.admin?
  end

  def set_target_user
    @user = User.find(params[:id])
  end

  def user_search_params
    params.fetch(:search, {}).permit(:name)
  end
end
