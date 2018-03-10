require 'rails_helper'

RSpec.describe User do
  let!(:user) { User.create(name: 'user') }

  let!(:posts) do
    [
      Post.create(user: user, title: 'title 1', content: 'post content 1', countable: true),
      Post.create(user: user, title: 'title 2', content: 'post content 2', countable: true)
    ]
  end

  before do
    posts.each do |post|
      Comment.create(user: user, post: post, content: 'comment content 1')
      Comment.create(user: user, post: post, content: 'comment content 2')
      Comment.create(user: user, post: post, content: 'comment content 3')
    end
  end

  describe '#posts_count' do
    it do
      expect(user.posts_count).to eq(user.posts.count)
    end

    it 'increment posts count' do
      expect {
        user.posts.create(title: 'new title', content: 'new comment content', countable: true)
      }.to change {
        user.posts_count
      }.by(1)
    end

    it 'decrement posts count' do
      expect {
        user.posts.last.destroy
      }.to change {
        user.posts_count
      }.by(-1)
    end

    it 'force reload' do
      Rails.cache.write(user._counter_cache_key('user', 'id', 'posts'), 1000)
      expect(user.posts_count).to eq 1000
      expect(user.posts_count(force: true)).to eq 2
    end

    context 'with conditional' do
      before do
        user.posts.create(title: 'new title', content: 'new comment content', countable: false)
      end

      it do
        expect(user.posts_count).to eq(user.posts.count - 1)
      end

      it 'does not increment posts count' do
        expect {
          user.posts.create(title: 'new title', content: 'new comment content', countable: false)
        }.to change {
          user.posts_count
        }.by(0)
      end

      it 'does not decrement posts count' do
        expect {
          user.posts.last.destroy
        }.to change {
          user.posts_count
        }.by(0)
      end

      it 'force reload' do
        expect(user.posts_count(force: true)).to eq 2
      end
    end
  end

  describe '#comments_count' do
    it do
      expect(user.comments_count).to eq(user.comments.count)
    end

    it 'increment comments count' do
      expect {
        Comment.create(user: user, post: posts.sample, content: 'new comment content')
      }.to change {
        user.comments_count
      }.by(1)
    end

    it 'decrement comments count' do
      expect {
        user.comments.last.destroy
      }.to change {
        user.comments_count
      }.by(-1)
    end
  end
end
