class StaticPagesController < ApplicationController
  def home
    @posts = Post.page(params[:page]).per(3)
  end
end
