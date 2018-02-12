Rails.application.routes.draw do
  match "/graphql", to: "graphql#execute", via: [:get, :post, :options]
end
