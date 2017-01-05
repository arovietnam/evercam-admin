Rails.application.routes.draw do
  resources :archives
  resources :snapshot_extractors
  resources :snapshot_reports
  root to: 'users#index'

  devise_options = {
      controllers: {
          registrations: "registrations",
          passwords: "passwords"
      }
  }
  devise_for :users, devise_options

  resources :users, only: [:show, :index, :update] do
    get :impersonate, on: :member
  end

  resources :cameras do
    collection do
      get "merge"
    end
  end
  resources :camera_share_requests, path: "share-requests"
  resources :snapshots
  resources :vendors
  patch '/vendors' => 'vendors#update'

  resources :vendor_models, path: :models
  get '/models/load.vendor.model' => 'vendor_models#load_vendor_model'
  patch '/models' => 'vendor_models#update'
  delete "/models" => "vendor_models#delete"

  get '/dashboard' => 'dashboard#index'
  get '/map' => 'dashboard#map'
  get "/maps_gardashared" => "dashboard#maps_gardashared"
  get "/maps_construction" => "dashboard#maps_construction"
  get '/kpi' => 'dashboard#kpi'
  get '/no_access' => 'home#no_access'
  get "/cloud_recordings" => "snapshots#cloud_recordings"

  get "/licences/pending_reason" => "licence_reports#pending_reason"
  resources :licence_reports, path: "licences"
  post "/licences/new" => "licence_reports#create"
  delete "/licences/delete" => "licence_reports#destroy"
  patch "/licences/update" => "licence_reports#update"
  post "/licences/auto-renewal" => "licence_reports#auto_renewal"
  get "/load_users" => "users#load_users"
  get "/load_cameras" => "cameras#load_cameras"
  get "/intercom/user" => "users#get_intercom"
  get "/timelapse" => "timelapse_report#index"
  get "/snapshot_extractors_list" => "snapshot_extractors#list"
  get "/admins" => "admins#index"
  post "/admins/new" => "admins#create"
  delete "/admins/delete" => "admins#destroy"
  patch "/admins/update" => "admins#update"

  get "/meta_datas" => "meta_datas#index"
end
