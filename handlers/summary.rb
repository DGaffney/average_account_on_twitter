get "/summary/latest.json" do
end

get "/latest_stats" do
  binding.pry
  @results = Hashie::Mash[Summary.first(:order => :created_at.desc).results]
  erb :"summary/latest", :layout => :"layouts/public"
end