before "/compare/:screen_name*" do
  @results = {}
  summary = nil
  offset = 0
  while summary.nil?
    dataset = Dataset.first(:name => Setting.for("default_dataset_name"), :order => :created_at.desc, :summary_id.ne => nil, :offset => offset)
    summary = dataset.summary
    offset+=1
    break if offset >= Dataset.count(:name => Setting.for("default_dataset_name"), :summary_id.ne => nil)
  end
  @results[:user] = current_user.twitter_data_for(params[:screen_name].split(".").first)
  @results[:latest_summary] = Hashie::Mash[summary.results]
end
