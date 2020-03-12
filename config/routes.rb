Rails.application.routes.draw do
  resources :spaces, except: [:new, :edit, :update], param: :slug, shallow: true do
    resources :categories
    resources :lists, except: [:index] do
      get 'css', on: :member
      get 'example', on: :member
      resources :tokens, except: [:new, :show]
    end
  end
  root 'home#show'
  get ':slug', to: 'spaces#show'
end
