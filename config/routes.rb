Rails.application.routes.draw do

=begin
  controller :icons do
    get 'icons/:id', :to => "icons#show"
    get 'icons', :to => "icons#index"
  end



  controller :dashboard do
    get 'dashboard' => 'dashboard#index', :as => :dashboard
    #get 'dashboard/performance_tile' => 'dashboard#performance_tile', as: :dashboard_performance_tile
  end

    controller :notifications do
      get 'list' => 'notifications#list', :as => :notifications_list
      get 'unread_count' => 'notifications#unread_count', :as => :notifications_unread_count
      post 'mark_all_as_read' => 'notifications#mark_all_as_read', :as => :mark_notifications_as_read
    end

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

  controller :service_requests do
    get 'service_requests', :to => "service_requests#index"
    get 'service_requests/:id', :to => "service_requests#show"
  end

  controller :chats do
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
