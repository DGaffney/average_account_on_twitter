get "/latest_stats" do
  erb :"summary/show", :layout => :"layouts/public"
end

get "/latest_stats.json" do
  content_type :json
  return @results.to_json
end

get "/stats/:dataset_id" do
  erb :"summary/show", :layout => :"layouts/public"
end

get "/stats/:dataset_id" do
  content_type :json
  return @results.to_json
end
get "/stats" do
  erb :"summary/index", :layout => :"layouts/public"
end

get "/stats" do
  content_type :json
  return @datasets.to_json
end

get "/stats/page/:page" do
  erb :"summary/index", :layout => :"layouts/public"
end

get "/stats/page/:page.json" do
  content_type :json
  return @datasets.to_json
end

get "/longitudinal" do
  erb :"summary/longitudinal", :layout => :"layouts/public"
end

get "/longitudinal.json" do
  content_type :json
  return {:results => @results, :executive_summary => @executive_summary}.to_json
end