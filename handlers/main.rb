get '/' do
  erb :index, :layout => :"layouts/public"
end

get '/.json' do
  return {:wat => "r u doin."}
end