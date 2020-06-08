class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_target_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.all.includes(:user)
    @like = Like.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿しました！"
      redirect_to @post
    else
      flash.now[:error_messages] = @post.errors.full_messages
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      flash[:notice] = "更新しました！"
      redirect_to @post
    else
      redirect_back fallback_location: @post, flash: {
        error_messages: @post.errors.full_messages
      }
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿削除しました！"
    redirect_to search_posts_url
  end

  def cities_select
    if request.xhr?
      render partial: 'cities', locals: { prefecture_id: params[:prefecture_id]}
    end
  end

  def search
    @search_params = post_search_params
    @posts = Post.search(@search_params).page(params[:page]).per(6).includes(:user, :prefecture, :city)
  end

  def rank
    @rank_posts = Post.unscoped.joins(:likes).group(:post_id).order('count(post_id) desc').page(params[:page]).per(6).includes(:user, :prefecture, :city)
  end

  private

    def post_params
      params.require(:post).permit(:name, :body, :picture, :picture_cache, :prefecture_id, :city_id, :latitude, :longitude)
    end

    def correct_user
      redirect_back(fallback_location: user_url(current_user)) unless (@post.user == current_user) || current_user.admin?
    end

    def set_target_post
      @post = Post.find(params[:id])
    end

    def post_search_params
      params.fetch(:search, {}).permit(:name, :prefecture_id, :city_id)
    end
end
