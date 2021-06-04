# frozen_string_literal: true

require 'spec_helper'

describe VendHandler do
  describe '#call' do
    subject { vend_handler.call }

    let(:vend_handler) { VendHandler.new(screen, bank, warehouse) }
    let(:screen) { Screen.new }
    let(:bank) { Bank.new }
    let(:warehouse) { Warehouse.new }
    let(:id) { 2 }
    let(:available_product) { true }
    let(:product) { OpenStruct.new({ id: 2, name: 'Pepsi', price: 1.0 }) }
    let(:coin2) { OpenStruct.new({ id: 2, name: '3$', value: 3.00 }) }
    let(:coin3) { OpenStruct.new({ id: 3, name: '2$', value: 2.00 }) }
    let(:change_coin_processor_instance) { instance_double(ChangeCoinProcessor, call: processor_result) }
    let(:processor_result) { { 3 => 1 } }

    before do
      allow(screen).to receive(:select_options) { id }
      allow(screen).to receive(:error)
      allow(screen).to receive(:info)
      allow(warehouse).to receive(:available?) { available_product }
      allow(warehouse).to receive(:find) { product }
      allow(bank).to receive(:find).with(2) { coin2 }
      allow(bank).to receive(:find).with(3) { coin3 }
      allow(ChangeCoinProcessor).to receive(:new) { change_coin_processor_instance }
    end

    it 'calls screen info' do
      subject
      expect(screen).to have_received(:info).with("Selected #{product.name}, please deposit #{product.price}$")
      expect(screen).to have_received(:info).with("Here is your: #{product.name}")
      expect(screen).to have_received(:info).with('And your change of 2.0$, coins: 2$ - 1 pcs')
    end

    it 'calls ChangeCoinProcessor' do
      subject
      expect(ChangeCoinProcessor).to have_received(:new).with(bank, 2.00)
    end

    context 'when product nil' do
      let(:product_id) { 10 }

      it { is_expected.to be_nil }
    end

    context 'when product is unavailable' do
      let(:available_product) { false }

      it 'calls screen error' do
        subject
        expect(screen).to have_received(:error).with('Current product is out of stock')
      end
    end

    context 'when can\'t prepare change' do
      let(:processor_result) { nil }

      it 'calls screen error' do
        subject
        expect(screen).to have_received(:error)
          .with('Sorry, we can\'t prepare change for this amount. Take your money!')
      end
    end
  end
end
