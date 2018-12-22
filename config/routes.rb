Rails.application.routes.draw do
  devise_for :users, skip: [:registrations], controllers:{ sessions: 'users/sessions'}

  use_doorkeeper scope: 'api' do
    skip_controllers :applications, :authorized_applications
  end

  scope module: :api, defaults: { format: :json }, path: 'api' do
    devise_for :users,
      path: '',
      path_names: {
        registration: 'register'
      },
      controllers: {
        registrations: 'api/users/registrations',
      },
      skip: [:sessions, :passwords]

    resources :balances, only: [:index]
  end

  scope module: :admin, path: 'admin' do

  end
end
