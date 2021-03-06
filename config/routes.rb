Rails.application.routes.draw do

=begin
  resources :projects do
    resources :comments
    resources :photos
    collection do
      get :deleted
    end
    member do
      post :link_tasks
      #post :finish
    end
  end
=end

  root :to => "admin_dashboard#index"
  get '/:locale' => 'admin_dashboard#index', locale: /#{I18n.available_locales.join("|")}/

  controller :trip_assistant do
    get 'trip_assistant', :to => "trip_assistant#index"
  end

  controller :service_requests do
    get 'service_requests', :to => "service_requests#index"
    get 'service_requests/:id', :to => "service_requests#show"
  end

  resources :trips do
    # stub
  end

  resources :trip_destinations do
    # stub
    get 'card', :to => "trip_destinations#card"
  end

  # TODO chatbot greetng and query param

  controller :traveller_profiles do
    get 'traveller_profiles', :to => "traveller_profiles#index"
    get 'traveller_profiles/:id', :to => "traveller_profiles#show"
  end

  controller :chats do
    get 'chats', :to => "chats#index"
    get 'chat_node', :to => "chats#chat_node"
  end

  controller :ibm_watson do
    get  'ask_watson_assistant', :to => 'ibm_watson#ask_assistant', :as => 'ask_watson_assistant'
  end

  resources :tickets do
    collection do
      get :deleted
    end
  end

  # get '*unmatched_route', :to => 'home#index'
end
