# frozen_string_literal: true

module CacheHelper
  extend ActiveSupport::Concern

  included do
    around_action :fetch_cache
  end

  def fetch_cache
    if cache_mapping
      if cache_mapping.hit?
        response.body = cache_mapping.read
        response.content_type = "application/json"
      else
        yield
        cache_mapping.write(response.body) if response.ok?
      end
    else
      yield
    end
  end

  def cache_mapping
    @cache_mapping ||= if cache_mapping_klass
      cache_mapping = cache_mapping_klass.new(params)
      cache_mapping.respond_to?(params[:action]) ? cache_mapping : nil
    end
  end

  def cache_mapping_klass
    @klass ||= "#{params[:controller].camelize}CacheMapping".constantize
  rescue NameError
    nil
  end
end
