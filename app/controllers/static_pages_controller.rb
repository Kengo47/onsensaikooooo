class StaticPagesController < ApplicationController
  def home
    @posts = Post.page(params[:page]).per(10)
  end
end
