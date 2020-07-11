class StaticPagesController < ApplicationController
  def home
    @posts = Post.page(params[:page]).per(12)
    @post_json = Post.all.to_json(only: %i[id name picture latitude longitude])
    @chart = Post.unscope(:order).joins(:prefecture).group('prefectures.name').order('count_all DESC').limit(10).count
  end
end
