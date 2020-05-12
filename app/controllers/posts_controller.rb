class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_target_post, only: [:show, :edit, :update, :destroy]

  def new
    if user_signed_in?
      @post = current_user.posts.build
    end
  end

  def show

  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿しました！"
      redirect_to root_url
    else
      render 'posts/new'
    end
  end

  def edit

  end

  def update
    if @post.update_attributes(post_params)
      flash[:notice] = "Post updated"
      redirect_to root_url
    else
      render 'posts/edit'
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿削除しました！"
    redirect_to root_url
  end

  private

    def post_params
      params.require(:post).permit(:title, :body, :image)
    end

    def set_target_post
      @post = Post.find(params[:id])
    end
end
