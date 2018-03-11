# frozen_string_literal: true

module CounterCacheRails
  class Configuration
    attr_accessor :expires_in

    def initialize(expires_in:)
      @expires_in = expires_in
    end
  end
end
