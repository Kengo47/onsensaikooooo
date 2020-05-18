class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_target_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def show
    @comment = Comment.new(post_id: @post.id)
    @comments = @post.comments.all
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿しました！"
      redirect_to root_url
    else
      redirect_to new_post_path, flash: {
        error_messages: @post.errors.full_messages
      }
    end
  end

  def edit
    # @post.picture.cache! unless @post.picture.blank?
  end

  def update
    if @post.update_attributes(post_params)
      flash[:notice] = "更新しました！"
      redirect_to root_url
    else
      redirect_back fallback_location: @post, flash: {
        error_messages: @post.errors.full_messages
      }
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿削除しました！"
    redirect_to root_url
  end

  def cities_select
    if request.xhr?
      render partial: 'cities', locals: { prefecture_id: params[:prefecture_id]}
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :body, :picture, :picture_cache, :prefecture_id, :city_id)
    end

    def set_target_post
      @post = Post.find(params[:id])
    end
end
