get "/summary/latest.json" do
end

get "/latest_stats" do
  @results = Hashie::Mash[Summary.first(:order => :created_at.desc).results]
end