Rails.application.routes.draw do
  get '/sleep_records', to: 'sleep_records#index'
  post '/sleep_records/clock_in', to: 'sleep_records#create'
end
