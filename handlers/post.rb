get "/posts.json" do
  return @posts.to_json
end

get "/posts" do
  erb :"posts/index", :layout => :"layouts/public"
end

get "/posts/:slug.json" do
  return @post.to_json
end

get "/posts/:slug" do
  erb :"posts/show", :layout => :"layouts/public"
end
