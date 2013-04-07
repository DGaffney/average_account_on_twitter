get "/compare/:screen_name" do
  @results = {}
  @results[:user] = current_user.twitter_data
  @results[:latest_summary] = Hashie::Mash[Summary.first(:order => :created_at.desc).results]
  erb :compare, :layout => :"layouts/public"
end