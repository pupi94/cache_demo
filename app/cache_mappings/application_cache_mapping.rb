# frozen_string_literal: true

class ApplicationCacheMapping
  attr_reader :params, :extra_options

  EXCEPT_PARAMS_KEY = %i[format controller action]

  def initialize(params, extra_options = {})
    @params = params
    @extra_options = extra_options
  end

  def hit?
    read.present?
  end

  def write(data)
    Rails.cache.write(key_by_action, data)
    Rails.cache.redis.sadd(redis_set_key, key_by_action)
  end

  def read
    @data ||= Rails.cache.read(key)
  end

  def key
    @key ||= self.send(params[:action].to_sym)
  end

  class << self
    def delete_matched(key)
      keys = Rails.cache.redis.smembers("#{key}::key_set")
      keys << key
      Rails.cache.redis.del(keys)
    end
  end

  private
    def request_params
      Digest::MD5.hexdigest(params.to_unsafe_h.except(*EXCEPT_PARAMS_KEY).to_query)
    end

    def action_info
      "#{params[:controller]}:#{params[:action]}:#{params[:format]}:#{extra_options.to_query}"
    end

    def key_by_action
      @key ||= "#{key_prefix}/#{action_info}/#{request_params}"
    end

    def key_prefix
      @key_prefix ||= self.send(params[:action].to_sym)
    end

    def redis_set_key
      @redis_set_key ||= "#{key_prefix}::key_set"
    end
end
