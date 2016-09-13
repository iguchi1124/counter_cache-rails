# frozen_string_literal: true
module CounterCacheRails
  class Railtie < ::Rails::Railtie
    initializer 'counter_cache-rails' do
      ActiveSupport.on_load(:active_record) do
        require 'counter_cache_rails/active_record_extention'
        ::ActiveRecord::Base.send :include, ActiveRecordExtention
      end
    end
  end
end
