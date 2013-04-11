get "/compare/:screen_name.json" do
  return @results.to_json
end

get "/compare/:screen_name" do
  erb :compare, :layout => :"layouts/public"
end