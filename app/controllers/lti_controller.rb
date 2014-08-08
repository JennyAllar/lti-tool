
class LtiController < ApplicationController

  # TODO: pull name / role / context title from params and print them out instead of hard-coding

  $oauth_creds = {"test" => "secret", "testing" => "supersecret"}

  CONSUMER_KEY = "jisc.ac.uk"
  CONSUMER_SECRET = "secret"

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
        @tp = IMS::LTI::ToolProvider.new(nil, nil, params)
        @tp.lti_msg = "Your consumer didn't use a recognized key."
        @tp.lti_errorlog = "You did it wrong!"
        return false
      end
    else
      show_error "No consumer key"
      return false
    end

    if correct?
      render index
    else
      render text: "Invalid Request"
    end
  end

  # TODO: do crazy oauth shit to verify request

  def correct?
    if params[:oauth_consumer_key] == CONSUMER_KEY
      true
    else
      false
    end
  end
end