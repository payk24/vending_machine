# frozen_string_literal: true

class Warehouse
  PRODUCTS = [
    OpenStruct.new({ id: 1, name: 'Cola', price: 1.5 }),
    OpenStruct.new({ id: 2, name: 'Pepsi', price: 1.0 }),
    OpenStruct.new({ id: 3, name: 'Fanta', price: 1.75 }),
    OpenStruct.new({ id: 4, name: 'Sprite', price: 0.75 }),
    OpenStruct.new({ id: 5, name: 'Mirinda', price: 2.5 }),
    OpenStruct.new({ id: 6, name: 'Biola', price: 0.5 })
  ].freeze

  def initialize
    @warehouse = inventory
  end

  def list_of_products
    @list_of_products ||= PRODUCTS.map { |item| { name: "#{item.name} #{item.price}$", value: item.id } }
  end

  def products_count
    PRODUCTS.map { |item| [item.name, warehouse.fetch(item.id)] }
  end

  def find(id)
    PRODUCTS.detect { |item| item.id == id }
  end

  def available?(product)
    warehouse.fetch(product.id, 0).positive?
  end

  def dec_product(product)
    warehouse[product.id] -= 1
  end

  private

  attr_reader :warehouse

  def inventory
    PRODUCTS.inject({}) { |res, item| res.merge(item.id => rand(0..3)) }
  end
end
