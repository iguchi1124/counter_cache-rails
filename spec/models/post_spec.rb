require 'rails_helper'

RSpec.describe Post do
  let!(:user) { User.create(name: 'user') }
  let!(:post) { Post.create(user: user, title: 'title', content: 'post content') }

  before do
    post.comments.create(user: user, content: 'comment content 1')
    post.comments.create(user: user, content: 'comment content 2')
  end

  describe '#comments_count' do
    it do
      expect(post.comments_count).to eq(post.comments.count)
    end

    it 'increment comments count' do
      expect {
        post.comments.create(user: user, content: 'new comment content')
      }.to change {
        post.comments_count
      }.by(1)
    end

    it 'decrement comments count' do
      expect {
        post.comments.last.destroy
      }.to change {
        post.comments_count
      }.by(-1)
    end
  end
end
