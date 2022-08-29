class TweetsController < ApplicationController
  def index
    render json: Tweet.limit(10).offset(params[:offset]).order('created_at DESC')
  end
end

