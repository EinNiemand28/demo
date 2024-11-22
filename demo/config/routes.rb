Rails.application.routes.draw do
  devise_for :users
  resources :events do
    member do
      patch :approve
      patch :cancel
    end
    resources :student_events, only: [:create, :destroy]
    resources :teacher_events, only: [:create, :destroy]

    resources :volunteer_positions do
      member do
        post :apply, to: "student_volunteer_positions#create", as: :apply
        patch "approve/:registration_id", to: "student_volunteer_positions#approve", as: :approve
        patch "cancel", to: "student_volunteer_positions#cancel", as: :cancel
      end
    end
    resources :feedbacks, except: [:show]
  end
  resources :users do
    member do
      delete "reset_avatar", to: "users#reset_avatar", as: :reset_avatar
    end
  end
  resources :notifications do
    member do
      patch :toggle_read
    end
  end
  get "welcome/index"
  root "welcome#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
