class Dataset
  include MongoMapper::Document
  key :time_start, DateTime
  key :time_end, DateTime
  key :name, String
  many :users, :in => :user_ids
  belongs_to :summary
  timestamps!
  safe
end