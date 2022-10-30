Rails.application.routes.draw do
  post '/', to: "short_urls#create"
  get '/:short_id', to: "short_urls#redirect", constraints: { id: /[A-Z]\d{7}/ }

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
end
