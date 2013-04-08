class Post
  include MongoMapper::Document
  key :content, String
  key :slug, String
  key :title, String
  belongs_to :account
  timestamps!
  safe
end