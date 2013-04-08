get '/' do
  erb :index, :layout => :"layouts/public"
end

get '/.json' do
  content_type :json
  return {:wat => "r u doin."}
end