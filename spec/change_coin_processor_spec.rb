# frozen_string_literal: true

require 'spec_helper'

describe ChangeCoinProcessor do
  describe '#call' do
    subject { change_coin_processor.call }

    let(:change_coin_processor) { ChangeCoinProcessor.new(bank, change) }
    let(:change) { 2.0 }
    let(:bank) { Bank.new }
    let(:available_coins) { { 1 => 1, 2 => 2, 3 => 3 } }

    before { allow(bank).to receive(:available_coins) { available_coins } }

    it { is_expected.to eq({ 3 => 1 }) }

    context 'when correctly to choose the not most expensive coin' do
      let(:available_coins) { { 1 => 1, 2 => 2, 3 => 3, 5 => 10 } }
      let(:change) { 4.0 }

      it { is_expected.to eq({ 3 => 2 }) }
    end

    context 'when need a few coins' do
      let(:available_coins) { { 1 => 1, 2 => 2, 3 => 3, 5 => 10 } }
      let(:change) { 4.5 }

      it { is_expected.to eq({ 3 => 2, 5 => 1 }) }
    end

    context 'when not enough count coins for the best solution, choose next solution' do
      let(:available_coins) { { 1 => 1, 2 => 2, 3 => 1, 5 => 10 } }
      let(:change) { 4.0 }

      it { is_expected.to eq({ 2 => 1, 5 => 2 }) }
    end

    context 'when change can\'t be divided' do
      let(:available_coins) { { 1 => 1, 2 => 2, 3 => 1, 5 => 10 } }
      let(:change) { 4.25 }

      it { is_expected.to be_nil }
    end
  end
end
