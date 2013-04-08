class Account
  include MongoMapper::Document
  key :screen_name, String
  key :user_id, Integer
  key :oauth_token, String
  key :oauth_token_secret, String
  key :post_ids, Array
  many :posts
  timestamps!
  safe
  
  def twitter_data_for(screen_name)
    client = Twitter::Client.new(Setting.twitter_credentials_with_user(self))
    return client.user(screen_name)
  end
end