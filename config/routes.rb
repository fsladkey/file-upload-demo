Rails.application.routes.draw do
  root to: 'static_pages#root'
  resources :tweets

  namespace :api do
    resources :tweets, only: [:index, :create, :show]
  end


end


# using the keyword "resources" will build the 7 routes.
# you can make custom routes, but not thru "resources"


#  goal: see all the tweets!
# get "/tweets", to: "tweets#index"
#
# #  goal: see one tweet
# get "/tweets/:id", to: "tweets#show"
#
# #  goal: create a tweet
# post "/tweets", to: "tweets#create"
