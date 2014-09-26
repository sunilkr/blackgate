Rails.application.routes.draw do
  root to: 'dashboard#index'

  resources :incidents do
    resources :samples, only: [:new]
    member do
      delete "samples/:sample_id", to: "incidents#delete_sample", as: "delete_sample"
      get 'samples', to: 'incidents#samples' 
    end
  end

  resources :samples, only: [:index, :show, :edit, :update, :destroy, :create] do
    member do
      get "/download", to: "samples#download"
    end
  end

end
