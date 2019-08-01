# frozen_string_literal: true

class ProductListener
  def product_created(product)
    ProductsCacheMapping.clear(product.id)
  end

  def product_updated(product)
    ProductsCacheMapping.clear(product.id)
  end

  def product_deleted(product)
    ProductsCacheMapping.clear(product.id)
  end
end
