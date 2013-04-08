get '/.json' do
  return {:wat => "r u doin."}
end

get '/' do
  erb :index, :layout => :"layouts/public"
end