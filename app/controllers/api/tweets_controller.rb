class Api::TweetsController < ApplicationController

  def index
    @tweets = Tweet.includes(:author).all
  end

  def create
    @tweet = User.find_by(name: "Fred").tweets.create(tweet_params)
    render :show
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body)
  end
end
