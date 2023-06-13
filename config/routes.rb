Rails.application.routes.draw do
  # Sleep Records
  resources :sleep_records, only: [:index] do
    collection do
      post 'clock_in', to: 'sleep_records#create'
    end
  end

  # Users
  resources :users, only: [] do
    member do
      post 'follow'
      delete 'unfollow'
    end

    # Followed Sleep Records
    get 'followed_sleep_records', to: 'users#followed_sleep_records', on: :member
  end
end