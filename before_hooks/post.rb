before "/posts/:slug*" do
  @post = Post.first(:slug => params[:slug])
end

before "/posts*" do
  @posts = Post.all
end