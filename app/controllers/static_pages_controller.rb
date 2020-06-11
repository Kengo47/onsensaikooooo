class StaticPagesController < ApplicationController
  def home
    @posts = Post.page(params[:page]).per(6)
    @post_json = Post.all.to_json(only: %i[id name picture latitude longitude])
    @chart = Prefecture.joins(:posts).group(:name).count
  end
end
