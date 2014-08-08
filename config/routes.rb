Rails.application.routes.draw do
  root 'lti#index'
  post 'lti_tool' => 'lti#index'
end
