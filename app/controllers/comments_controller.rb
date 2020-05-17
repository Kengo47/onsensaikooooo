class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    comment  = current_user.comments.build(comment_params)
    if comment.save
      redirect_to comment.post
    else
      flash[:error] = comment.errors.full_messages
      redirect_to post_path(comment.post.id)
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:notice] = "コメント削除しました"
    redirect_to comment.post
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :post_id, :user_id)
  end
end