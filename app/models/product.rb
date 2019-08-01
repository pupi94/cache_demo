class Product < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }

  after_update_commit :publish_update_event
  after_destroy_commit :publish_destroy_event
  after_create_commit :publish_create_event

  def publish_update_event
    ProductPublisher.publish(:product_updated, self)
  end

  def publish_create_event
    ProductPublisher.publish(:product_created, self)
  end

  def publish_destroy_event
    ProductPublisher.publish(:product_deleted, self)
  end
end