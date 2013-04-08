before "/compare/:screen_name*" do
  @results = {}
  @results[:user] = current_user.twitter_data_for(params[:screen_name].split(".").first)
  @results[:latest_summary] = Hashie::Mash[Summary.first(:order => :created_at.desc).results]
end
