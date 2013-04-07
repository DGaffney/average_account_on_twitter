module TwitterHelper

  private

  def oauth_client
    OAuth::Consumer.new(Setting.for("twitter_consumer_key"), Setting.for("twitter_consumer_secret"), { :site => "http://api.twitter.com" })
  end

  def prepare_token(redirect_path)
    redirect_url = "http://#{Setting.for("twitter_callback")}/twitter_callback"
    request_token = oauth_client.get_request_token( :oauth_callback => redirect_url )
    [request_token, redirect_url]
  end
  
  def get_token_credentials
    access_token = session[:request_token].get_access_token( :oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier] )
    screen_name = access_token.params[:screen_name]
    oauth_token = access_token.params[:oauth_token]
    oauth_token_secret = access_token.params[:oauth_token_secret]
    return access_token
  end
end
