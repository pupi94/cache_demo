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
    Rails.cache.write(key, data)
  end

  def read
    @data ||= Rails.cache.read(key)
  end

  def key
    @key ||= self.send(params[:action].to_sym)
  end

  private
    def request_params
      Digest::MD5.hexdigest(params.to_unsafe_h.except(*EXCEPT_PARAMS_KEY).to_query)
    end

    def action_info
      "#{params[:controller]}:#{params[:action]}:#{params[:format]}:#{extra_options.to_query}"
    end
end
