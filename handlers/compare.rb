get "/compare/:screen_name" do
  @results = {}
  @results[:user] = current_user.twitter_data
  @results[:latest_summary] = Summary.first(:order => :created_at.asc)
  erb :compare, :layout => :"layouts/public"
end