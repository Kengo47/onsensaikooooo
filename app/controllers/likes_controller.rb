class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = current_user.likes.create(post_id: @post.id)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def destroy
    @like = Like.find_by(post_id: @post.id, user_id: current_user.id)
    @like.destroy
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
