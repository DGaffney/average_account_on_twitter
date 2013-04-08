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

get "/stats/:dataset_id" do
  dataset = Dataset.first(:id => params[:dataset_id])
  summary = dataset.summary
  @results = summary.nil? ? Hashie::Mash[] : Hashie::Mash[summary.results]
  @results.finished_at = dataset.updated_at
  erb :"summary/show", :layout => :"layouts/public"
end

get "/stats" do
  params[:per_page] = params[:per_page] || 100
  page = params[:page] || 1
  @datasets = Dataset.paginate({
    :order    => :created_at.desc,
    :name => Setting.for("default_dataset_name"),
    :summary_id.ne => nil,
    :per_page => params[:per_page].to_i, 
    :page     => page.to_i
  })
  erb :"summary/index", :layout => :"layouts/public"
end

get "/stats/page/:page" do
  params[:per_page] = params[:per_page] || 100
  page = params[:page] || 1
  @datasets = Dataset.paginate({
    :order    => :created_at.desc,
    :name => Setting.for("default_dataset_name"),
    :summary_id.ne => nil,
    :per_page => params[:per_page].to_i, 
    :page     => page.to_i
  })
  erb :"summary/index", :layout => :"layouts/public"
end

get "/longitudinal" do
  @results = {}
  case (params[:length]||="all_time")
  when "day"
    Dataset.all(:order => :created_at.desc, :created_at.gte => Time.now-24*60*60).collect{|d| @results[d.created_at] = d.summary.nil? ? {} : d.summary.results}
  when "week"
    Dataset.all(:order => :created_at.desc, :created_at.gte => Time.now-24*60*60*7).collect{|d| @results[d.created_at] = d.summary.nil? ? {} : d.summary.results}
  when "month"
    Dataset.all(:order => :created_at.desc, :created_at.gte => Time.now-24*60*60*7*4).collect{|d| @results[d.created_at] = d.summary.nil? ? {} : d.summary.results}
  when "year"
    Dataset.all(:order => :created_at.desc, :created_at.gte => Time.now-24*60*60*7*365).collect{|d| @results[d.created_at] = d.summary.nil? ? {} : d.summary.results}
  when "all_time"
    Dataset.all(:order => :created_at.desc).collect{|d| @results[d.created_at] = d.summary.nil? ? {} : d.summary.results}
  end
  erb :"summary/longitudinal", :layout => :"layouts/public"
end