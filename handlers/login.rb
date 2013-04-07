get "/login" do
  redirect "/" if current_user
  request_token, redirect_url = prepare_token("/twitter_callback")
  session[:request_token] = request_token
  redirect request_token.authorize_url(:oauth_callback => redirect_url)  
end

get "/twitter_callback" do
  credentials = get_token_credentials
  raise "Can't handle this here." unless credentials.params[:screen_name]
  account = Account.first_or_create(:twitter_id => credentials.params[:user_id], :screen_name => credentials.params[:screen_name], :oauth_token => credentials.params[:oauth_token], :oauth_token_secret => credentials.params[:oauth_token_secret])
  account.save!
  session[:account_id] = account.id
  redirect "/compare/#{account.screen_name}"
end

get "/logout" do
  session.delete(:account_id)
  redirect "/"
end
