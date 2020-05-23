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
  end

  def read
    @result ||= Rails.cache.read(key_by_action)
  end

  class << self
    def increase_version(key_prefix)
      Rails.cache.redis.with { |con| con.incr(version_key(key_prefix)) }
    end

    def version_key(key_prefix)
      "#{key_prefix}::version"
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
      @key ||= "#{key_prefix}/#{version}/#{action_info}/#{request_params}"
    end

    def key_prefix
      @key_prefix ||= self.send(params[:action].to_sym)
    end

    def version
      Rails.cache.read(self.class.version_key(key_prefix))
    end
end
