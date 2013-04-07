class Account
  include MongoMapper::Document
  key :screen_name, String
  key :user_id, Integer
  key :oauth_token, String
  key :oauth_token_secret, String
  timestamps!
  safe
  
  def twitter_data
    client = Twitter::Client.new(Setting.twitter_credentials_with_user(self))
    return client.user(self.screen_name)
  end
end