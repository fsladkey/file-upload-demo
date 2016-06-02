class Api::TweetsController < ApplicationController

  def index
    @tweets = Tweet.includes(:author).all
  end

  def create
    tweet = Tweet.create(tweet_params)
    render :show
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body, :author_id)
  end
end
