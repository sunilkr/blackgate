Rails.application.routes.draw do

  root to: 'dashboard#index'

  resources :incidents do
    resources :samples, only: [:new]
    member do
      delete "samples/:sample_id", to: "incidents#delete_sample", as: "delete_sample"
      get 'samples', to: 'incidents#samples' 
    end
  end

  resources :samples, except: [:new] do
    resources :cnc_traffics, path: 'traffics'
    member do
      get "/download", to: "samples#download"
    end
  end

  resources :command_and_controls, path: 'cncs' do
    resources :cnc_traffics, only:[:index, :show], as: 'traffics', path: 'traffics'
  end
end
