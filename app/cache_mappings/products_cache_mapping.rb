# frozen_string_literal: true

class ProductsCacheMapping < ApplicationCacheMapping
  def show
    "product:#{Digest::MD5.hexdigest(params[:id])}/#{action_info}"
  end

  def index
    "products/#{action_info}/#{request_params}"
  end

  class << self
    def clear(product_id)
      Rails.logger.info("============ Clear products cache : #{product_id}")

      Rails.cache.delete_matched("products/*")
      Rails.cache.delete_matched("product:#{product_id}/*")
    end
  end
end
