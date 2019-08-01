# frozen_string_literal: true

class ProductPublisher
  include Wisper::Publisher

  def self.publish(event, *args)
    self.new(event, args).call
  end

  attr_reader :event, :args
  def initialize(event, args)
    @event = event
    @args = args
  end

  def call
    broadcast(event, *args)
  end
end
