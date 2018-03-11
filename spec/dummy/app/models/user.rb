class User < ApplicationRecord
  has_many :posts
  has_many :comments

  counter_cache :posts, if: ->(post) { post.countable? }, scope: ->(posts) { posts.countable }
  counter_cache :comments
end
