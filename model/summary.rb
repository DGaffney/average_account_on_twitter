class Summary
  include MongoMapper::Document
  key :results
  belongs_to :dataset
end