load 'environment.rb'

TOP_USER_ID  = (ARGV[1] || Setting.for("top_user_id")).to_i
DATASET_NAME = ARGV[2] || Setting.for("default_dataset_name")
ITERATIONS   = (ARGV[3] || Setting.for("iterations")).to_i
BATCH_SIZE   = (ARGV[4] || Setting.for("batch_size")).to_i

task :run_stats do
  puts "Running task with TOP_USER_ID of #{TOP_USER_ID}, DATASET_NAME of #{DATASET_NAME}, ITERATIONS of #{ITERATIONS}, BATCH_SIZE of #{BATCH_SIZE}"
  dataset = Dataset.new(:time_start => Time.now, :name => DATASET_NAME)
  dataset.save
  user_set = []
  iterations = 0
  raise "TOP_USER_ID is smaller than ITERATIONS*BATCH_SIZE. Can't generate set of random numbers without replacement in this event." if ITERATIONS*BATCH_SIZE > TOP_USER_ID
  random_ids = Math.rand_n(ITERATIONS*BATCH_SIZE, TOP_USER_ID)
  #may want to consider threading these requests as they don't have to be done serially like this...
  random_ids.each_slice(BATCH_SIZE) do |rand_id_set|
    retry_count = 0
    account_to_study_with = Account.all.shuffle.first
    begin
    client = Twitter::Client.new(Setting.twitter_credentials_with_user(account_to_study_with))
    rand_ids = []
    user_set << client.users(rand_id_set)
    print "."
    rescue
      retry
    end
    iterations+=1
  end
  user_set = user_set.flatten
  summary = Summary.new(:dataset_id => dataset.id)
  dataset.summary_id = summary.id
  summary.results = {:total => user_set.length, :expected => iterations*100, :estimated_population => TOP_USER_ID*(user_set.length.to_f/(iterations*100))}
  user_information = {:statuses_count => [], :friends_count => [], :followers_count => [], :listed_count => [], :favourites_count => [], :created_at => [], :lang => [], :default_profile => [], :utc_offset => [], :time_zone => []}
  user_set.each do |user|
    user_information.keys.each do |k|
      user_information[k] << user[k]
    end
  end
  summary.results[:statuses_count]  = user_information[:statuses_count].all_stats
  summary.results[:friends_count]   = user_information[:friends_count].all_stats
  summary.results[:followers_count] = user_information[:followers_count].all_stats
  summary.results[:listed_count]    = user_information[:listed_count].all_stats
  summary.results[:created_at]      = user_information[:created_at].collect(&:to_i).all_stats
  summary.results[:created_at].each_pair do |k,v|
    summary.results[:created_at][k] = Time.at(v)
  end
  summary.results[:created_at_hour_min] = {}
  summary.results[:created_at].each_pair do |k,v|
    summary.results[:created_at_hour_min][k] = "#{Time.at(v).hour}:#{Time.at(v).min}"
  end
  summary.results[:lang] = user_information[:lang].counts
  summary.results[:default_profile] = {}
  user_information[:default_profile].counts.each do |k,v|
    summary.results[:default_profile][k.to_s] = v
  end
  summary.results[:utc_offset] = {}
  user_information[:utc_offset].counts.each do |k,v|
    summary.results[:utc_offset][k.to_s] = v
  end
  summary.results[:time_zone] = user_information[:time_zone].counts
  summary.results[:time_zone]["nil"] = summary.results[:time_zone].delete(nil)
  stored_count = 0
  old_model_counts = {}
  [Tweet, User, Url, UserMention, Hashtag, BoundingBox, Coordinate, Geo, Place, PlaceAttribute, Medium, Size].each do |model|
    old_model_counts[model.name] = model.count
  end
  invalid_accounts = 0
  weird_users = []
  user_set.each do |user|
    next if User.first(:twitter_id => user[:id], :dataset_id => dataset.id)
    begin
      if user.attrs
        user = User.new_from_raw(user.attrs)
        user.dataset_id = dataset.id
        user.save!
        stored_count+=1
      end
    rescue MongoMapper::DocumentNotValid
      invalid_accounts+=1
      weird_users << user.attrs
      puts "\nWeird Twitter is showing itself. Skipping record."
      next
    end
  end
  new_model_counts = {}
  [Tweet, User, Url, UserMention, Hashtag, BoundingBox, Coordinate, Geo, Place, PlaceAttribute, Medium, Size].each do |model|
    new_model_counts[model.name] = model.count
  end
  these_model_counts = {}
  [Tweet, User, Url, UserMention, Hashtag, BoundingBox, Coordinate, Geo, Place, PlaceAttribute, Medium, Size].each do |model|
    these_model_counts[model.name.downcase.to_sym] = new_model_counts[model.name]-old_model_counts[model.name]
  end
  summary.results[:counts] = these_model_counts
  summary.results[:invalid_accounts] = invalid_accounts
  dataset.time_end = Time.now
  dataset.save!
  summary.save!
end

task :setup_index do
  Tweet.ensure_index([[:twitter_id, 1]], :unique => true)
  User.ensure_index([[:twitter_id, 1], [:dataset_id, 1]], :unique => true)
end
