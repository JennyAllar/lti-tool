Rails.application.routes.draw do
  post 'lti_tool' => 'lti#index'
end
