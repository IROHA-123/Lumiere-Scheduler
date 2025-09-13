Rails.application.routes.draw do
  # Devise
  devise_for :users, skip: [:registrations]

  # root は devise_scope で囲む
  devise_scope :user do
    authenticated :user do
      root "staff/shift_requests#index", as: :authenticated_root
    end

    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end

  # スタッフ画面（Shift Scheduler）
  namespace :staff do
    resources :shift_requests, only: [:index, :create] do
      collection do
        get :modal, :my_shifts
      end
    end
  end

  # 管理者画面（Shift Manager）
  namespace :manager do
    resources :assignments, only: [:index] do
      patch :update_members, on: :collection
    end

    resources :confirmations, path: "confirmed", controller: "confirmed", only: [:index, :update] do
      get :download, on: :collection
    end

    resources :projects, only: [:index, :new, :create, :update] do
      member do
        get   :assignment
        patch :complete_assignment, :toggle_request
      end
    end

    resources :users, only: [:index, :new, :create, :edit, :update]
  end
end
