before "/latest_stats*" do
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
end

before "/stats/:dataset_id*" do
  dataset = Dataset.first(:id => params[:dataset_id].split(".").first)
  summary = dataset.summary
  @results = summary.nil? ? Hashie::Mash[] : Hashie::Mash[summary.results]
  @results.finished_at = dataset.updated_at
end

before "/stats*" do
  params[:per_page] = params[:per_page] || 100
  page = params[:page] || 1
  @datasets = Dataset.paginate({
    :order    => :created_at.desc,
    :name => Setting.for("default_dataset_name"),
    :summary_id.ne => nil,
    :per_page => params[:per_page].to_i, 
    :page     => page.to_i
  })
end

before "/stats/page/:page*" do
  params[:per_page] = params[:per_page] || 100
  page = (params[:page] && params[:page].split(".").first) || 1
  @datasets = Dataset.paginate({
    :order    => :created_at.desc,
    :name => Setting.for("default_dataset_name"),
    :summary_id.ne => nil,
    :per_page => params[:per_page].to_i, 
    :page     => page.to_i
  })
end

before "/longitudinal*" do
  @results = {}
  case (params[:length]||="all_time")
  when "day"
    Dataset.all(:name => Setting.for("default_dataset_name"), :order => :created_at.desc, :created_at.gte => Time.now-24*60*60).collect{|d| @results[d.created_at] = d.summary.results if d.summary}
  when "week"
    Dataset.all(:name => Setting.for("default_dataset_name"), :order => :created_at.desc, :created_at.gte => Time.now-24*60*60*7).collect{|d| @results[d.created_at] = d.summary.results if d.summary}
  when "month"
    Dataset.all(:name => Setting.for("default_dataset_name"), :order => :created_at.desc, :created_at.gte => Time.now-24*60*60*7*4).collect{|d| @results[d.created_at] = d.summary.results if d.summary}
  when "year"
    Dataset.all(:name => Setting.for("default_dataset_name"), :order => :created_at.desc, :created_at.gte => Time.now-24*60*60*7*365).collect{|d| @results[d.created_at] = d.summary.results if d.summary}
  when "all_time"
    Dataset.all(:name => Setting.for("default_dataset_name"), :order => :created_at.desc).collect{|d| @results[d.created_at] = d.summary.nil? ? {} : d.summary.results}
  end
  summary_data = {:estimated_population => [], :statuses_count => [], :friends_count => [], :followers_count => [], :favourites_count => [], :listed_count => [], :created_at => [], :default_profile => [], :invalid_accounts => [], :total => [], :total_statuses => [], :total_friends => []}
  at_least_fields = @results.values.collect(&:keys).flatten.uniq.select{|k| k.to_s.include?("at_least")}
  @results.values.select{|v| !v.empty?}.each do |result_set|
    [:statuses_count, :friends_count, :followers_count, :favourites_count, :listed_count, :created_at].each do |key|
      if key == :created_at
        summary_data[key] << result_set[key.to_s]["mean"].to_i if result_set[key.to_s]
      else
        summary_data[key] << result_set[key.to_s]["mean"] if result_set[key.to_s]
      end
    end
    summary_data[:estimated_population] << result_set["estimated_population"]
    summary_data[:default_profile] << (result_set["default_profile"]["true"]/result_set["default_profile"].values.sum.to_f)*result_set["estimated_population"] if result_set["default_profile"]
    summary_data[:invalid_accounts] << (result_set["invalid_accounts"]/result_set["expected"].to_f)*result_set["estimated_population"]
    summary_data[:total_statuses] << result_set["estimated_population"]*result_set["statuses_count"]["mean"]
    summary_data[:total_friends] << result_set["estimated_population"]*result_set["friends_count"]["mean"]
    summary_data[:total] << result_set["total"]
    at_least_fields.each do |at_least_field|
      summary_data[at_least_field.to_sym] = [] if summary_data[at_least_field.to_sym].nil?
      summary_data[at_least_field.to_sym] << (result_set[at_least_field]/result_set["expected"].to_f)*result_set["estimated_population"] if result_set[at_least_field]
    end
  end
  @executive_summary = {}
  summary_data.each_pair do |attribute, means|
    @executive_summary[attribute] = means.all_stats
  end
end