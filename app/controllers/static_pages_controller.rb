class StaticPagesController < ApplicationController
  def home
    @posts = Post.page(params[:page]).per(6)
  end
end
