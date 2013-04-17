class Setting
  include MongoMapper::Document
  key :name, String
  key :value
  
  def self.for(name)
    Setting.first(:name => name).value rescue nil
  end

  def self.all_for(name)
    Setting.all(:name => name).collect(&:value)
  end
  
  def self.twitter_credentials_with_user(user)
    {
      :oauth_token => user.oauth_token,
      :oauth_token_secret => user.oauth_token_secret,
      :consumer_key => Setting.for("twitter_consumer_key"),
      :consumer_secret => Setting.for("twitter_consumer_secret")
    }
  end
end