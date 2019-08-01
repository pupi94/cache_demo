# frozen_string_literal: true

Wisper.subscribe(ProductListener.new, scope: :ProductPublisher)
