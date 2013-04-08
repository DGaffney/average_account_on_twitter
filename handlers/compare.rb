get "/compare/:screen_name" do
  erb :compare, :layout => :"layouts/public"
end

get "/compare/:screen_name.to_json" do
  return @results.to_json
end
