before "/posts/:slug*" do
  @post = Post.first(:slug => params[:slug].split(".").first)
end

before "/posts*" do
  @posts = Post.all
end