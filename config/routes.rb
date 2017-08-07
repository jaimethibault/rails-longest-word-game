Rails.application.routes.draw do
  get 'init', to: "game#init"
  get 'score', to: "game#score"
  get 'game', to: "game#game"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
