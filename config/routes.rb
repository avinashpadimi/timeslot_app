Rails.application.routes.draw do
  get '/', to: 'welcome#index'
  resources :welcome, only: [:create,:index]
  resources :events, only: [:index] do 
    resources :timeslots, only: [:index]
  end
end
