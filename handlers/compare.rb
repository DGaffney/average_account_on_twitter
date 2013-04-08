get "/compare/:screen_name" do
  erb :compare, :layout => :"layouts/public"
end

get "/compare/:screen_name" do
  content_type :json
  return @results.to_json
end
