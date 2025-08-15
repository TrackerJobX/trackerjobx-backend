Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :users
      resources :tags
      resources :job_applications
      resources :attachments
      resources :interviews
      resources :plans

      # Auth Routes
      scope :auth do
        post "signup", to: "authentications#signup"
        post "signin", to: "authentications#signin"
        post "forgot_password", to: "authentications#forgot_password"
        get "profile", to: "authentications#profile"
        get "/verify_email", to: "email_verifications#verify", as: :verify_email
      end
    end
  end
end
