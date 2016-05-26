class Api::TweetsController < ApplicationController

  def index
    render json: Tweet.all
  end

  def create
    tweet = Tweet.create(tweet_params)
    render json: tweet
  end

  def show
    render json: Tweet.find(params[:id])
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body, :author_id)
  end
end
