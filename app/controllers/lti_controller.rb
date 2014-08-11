require 'ims/lti'
require 'oauth/request_proxy/rack_request'


class LtiController < ApplicationController

  $oauth_creds = {"ginkgo" => "secret", "tree" => "supersecret"}

  def index
    params.each do |k, v|
      if k.include?("oauth")
        Rails.logger.info "#{k} => #{v}"
      end
    end

    headers["X-Frame-Options"] = "ALLOW-FROM http://ltiapps.net/test/tc-launch.php"

    if key = params['oauth_consumer_key']
      if secret = $oauth_creds[key]
        @tp = IMS::LTI::ToolProvider.new(key, secret, params)
      else
        render text: "Invalid Request"
        @tp = IMS::LTI::ToolProvider.new(nil, nil, params)
        return false
      end
    else
      return false
    end
    
    @username = @tp.username("User")

  end

end