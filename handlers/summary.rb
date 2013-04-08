get "/latest_stats" do
  summary = nil
  offset = 0
  while summary.nil?
    dataset = Dataset.first(:name => Setting.for("default_dataset_name"), :order => :created_at.desc, :summary_id.ne => nil, :offset => offset)
    summary = dataset.summary
    offset+=1
    break if offset >= Dataset.count(:name => Setting.for("default_dataset_name"), :summary_id.ne => nil)
  end
  @results = Hashie::Mash[summary.results]
  @results.finished_at = dataset.updated_at
  erb :"summary/show", :layout => :"layouts/public"
end

get "/stats/:dataset_id"
  dataset = Dataset.first(:name => Setting.for("default_dataset_name"), :order => :created_at.desc, :summary_id.ne => nil, :offset => offset)
  summary = dataset.summary
  @results = summary.nil? ? Hashie::Mash[] : Hashie::Mash[summary.results]
  @results.finished_at = dataset.updated_at
  erb :"summary/show", :layout => :"layouts/public"
end