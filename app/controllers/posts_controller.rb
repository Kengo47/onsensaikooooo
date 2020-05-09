class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]

  def new
    @post = current_user.posts.build if user_signed_in?
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

  def destroy
    @post.destroy
    flash[:success] = "投稿削除しました！"
    redirect_to request.referrer || root_url
  end

  private

    def post_params
      params.require(:post).permit(:title, :body, :picture)
    end
end
