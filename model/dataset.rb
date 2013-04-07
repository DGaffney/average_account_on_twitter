class Dataset
  include MongoMapper::Document
  key :time_start, Time
  key :time_end, Time
  key :name, String
  many :users, :in => :user_ids
  belongs_to :summary
  timestamps!
  safe
end