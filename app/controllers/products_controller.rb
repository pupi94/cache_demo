class ProductsController < ApplicationController
  include CacheHelper

  before_action :load_product, only: %i[show destroy update]

  def index
    @products = search_products
  end

  def show
  end

  def destroy
    @product.destroy!
    render_ok
  end

  def create
    @product = Product.create!(product_params)
    render :show
  end

  def update
    @product.update!(product_params)
    render :show
  end

  private
    def search_products
      products = Product.all
      products = Product.where(title: params[:title].strip) if params[:title].present?
      products
    end

    def product_params
      params.require(:product).permit(%i[title description])
    end

    def load_product
      @product = Product.find(params[:id])
    end
end