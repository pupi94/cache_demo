# frozen_string_literal: true

class ProductsCacheMapping < ApplicationCacheMapping
  def show
    "product:#{params[:id]}"
  end

  def index
    "products"
  end

  class << self
    def clear(product_id)
      Rails.logger.info("============ Clear products cache : #{product_id}")

      delete_matched("products")
      delete_matched("product:#{product_id}")
    end
  end
end
