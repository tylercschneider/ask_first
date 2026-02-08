AskFirst::Engine.routes.draw do
  resources :consents, only: [:create]
end
