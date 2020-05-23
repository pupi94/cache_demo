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

      increase_version("products")
      increase_version("product:#{product.id}")
    end
  end
end
