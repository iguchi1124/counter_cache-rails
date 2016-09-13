# frozen_string_literal: true
module CounterCacheRails
  module ActiveRecordExtention
    extend ActiveSupport::Concern

    included do
      def self.counter_cache(tableized_model)
        class_name = self.to_s.downcase
        child_model_class = eval tableized_model.to_s.classify
        tableized_child_model = tableized_model.to_sym
        primary_key = self.primary_key.to_sym

        define_method "#{tableized_child_model}_count" do
          count = Rails.cache.read(_counter_cache_key(class_name, primary_key, tableized_child_model), raw: true)

          if count.nil?
            count = self.send(tableized_child_model).count
            Rails.cache.write(
              self._counter_cache_key(class_name, primary_key, tableized_child_model),
              count,
              raw: true
            )
          end

          count.to_i
        end

        define_method "_#{tableized_child_model}_count_incr" do
          Rails.cache.increment(_counter_cache_key(class_name, primary_key, tableized_child_model))
        end

        define_method "_#{tableized_child_model}_count_decr" do
          Rails.cache.decrement(_counter_cache_key(class_name, primary_key, tableized_child_model))
        end

        after_create do
          Rails.cache.write(
            self._counter_cache_key(class_name, primary_key, tableized_child_model),
            self.send(tableized_child_model).count,
            raw: true
          )
        end

        child_model_class.class_eval do
          after_create do
            self.send(class_name.to_sym).send("_#{tableized_child_model}_count_incr")
          end

          after_destroy do
            self.send(class_name.to_sym).send("_#{tableized_child_model}_count_decr")
          end
        end
      end

      def _counter_cache_key(class_name, primary_key, tableized_child_model)
        '_' + [class_name, self.send(primary_key), tableized_child_model].join('_')
      end
    end
  end
end
