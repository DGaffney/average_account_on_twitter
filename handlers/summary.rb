get "/summary/latest.json" do
end

get "/latest_stats" do
  binding.pry
  dataset = Dataset.first(:name => Setting.for("default_dataset_name"), :order => :created_at.desc, :summary_id.ne => nil)
  summary = dataset.summary
  @results = Hashie::Mash[summary.results]
  @results.finished_at = dataset.updated_at
  erb :"summary/latest", :layout => :"layouts/public"
end