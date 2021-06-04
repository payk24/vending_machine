# frozen_string_literal: true

require 'spec_helper'

describe Warehouse do
  let(:warehouse) { Warehouse.new }
  let(:warehouse_inventory) do
    {
      1 => 1,
      2 => 1,
      3 => 2,
      4 => 3,
      5 => 0,
      6 => 3
    }
  end

  before { allow_any_instance_of(Warehouse).to receive(:warehouse) { warehouse_inventory } }

  describe '#find' do
    subject { warehouse.find(id) }

    let(:id) { 2 }

    it { is_expected.to have_attributes(id: 2, name: 'Pepsi', price: 1.00) }
  end

  describe '#list_of_products' do
    subject { warehouse.list_of_products }

    let(:result) do
      [
        { name: 'Cola 1.5$', value: 1 },
        { name: 'Pepsi 1.0$', value: 2 },
        { name: 'Fanta 1.75$', value: 3 },
        { name: 'Sprite 0.75$', value: 4 },
        { name: 'Mirinda 2.5$', value: 5 },
        { name: 'Biola 0.5$', value: 6 }
      ]
    end

    it { is_expected.to eq(result) }
  end

  describe '#products_count' do
    subject { warehouse.products_count }

    let(:result) do
      [
        ['Cola', 1],
        ['Pepsi', 1],
        ['Fanta', 2],
        ['Sprite', 3],
        ['Mirinda', 0],
        ['Biola', 3]
      ]
    end

    it { is_expected.to eq(result) }
  end

  describe '#dec_product' do
    subject { warehouse.dec_product(product) }

    let(:product) { OpenStruct.new({ id: 6, name: 'Biola', price: 0.5 }) }
    let(:result) do
      {
        1 => 1,
        2 => 1,
        3 => 2,
        4 => 3,
        5 => 0,
        6 => 2
      }
    end

    it { is_expected.to eq(2) }
    it 'changes warehouse' do
      subject
      expect(warehouse.warehouse).to eq(result)
    end
  end

  describe '#available?' do
    subject { warehouse.available?(product) }

    let(:product) { OpenStruct.new({ id: 6, name: 'Biola', price: 0.5 }) }

    it { is_expected.to be_truthy }

    context 'when product is unavailable' do
      let(:product) { OpenStruct.new({ id: 5, name: 'Mirinda', price: 2.5 }) }

      it { is_expected.to be_falsey }
    end
  end
end
