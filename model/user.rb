class User
  include MongoMapper::Document
  belongs_to :dataset
  timestamps!
  safe
end