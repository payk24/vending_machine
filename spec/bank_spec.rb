# frozen_string_literal: true

require 'spec_helper'

describe Bank do
  let(:bank) { Bank.new }
  let(:bank_collection) do
    {
      1 => 1,
      2 => 1,
      3 => 2,
      4 => 3,
      5 => 0,
      6 => 3
    }
  end

  before { allow_any_instance_of(Bank).to receive(:bank) { bank_collection } }

  describe '#find' do
    subject { bank.find(id) }

    let(:id) { 2 }

    it { is_expected.to have_attributes(id: 2, name: '3$', value: 3.00) }
  end

  describe '#list_of_coins' do
    subject { bank.list_of_coins }

    let(:result) do
      [
        { name: '5$', value: 1 },
        { name: '3$', value: 2 },
        { name: '2$', value: 3 },
        { name: '1$', value: 4 },
        { name: '50c', value: 5 },
        { name: '25c', value: 6 }
      ]
    end

    it { is_expected.to eq(result) }
  end

  describe '#coins_count' do
    subject { bank.coins_count }

    let(:result) do
      [
        ['5$', 1],
        ['3$', 1],
        ['2$', 2],
        ['1$', 3],
        ['50c', 0],
        ['25c', 3]
      ]
    end

    it { is_expected.to eq(result) }
  end

  describe '#inc_coin' do
    subject { bank.inc_coin(coin) }

    let(:coin) { OpenStruct.new({ id: 2, name: '3$', value: 3.00 }) }
    let(:result) do
      {
        1 => 1,
        2 => 2,
        3 => 2,
        4 => 3,
        5 => 0,
        6 => 3
      }
    end

    it { is_expected.to eq(2) }
    it 'changes bank' do
      subject
      expect(bank.bank).to eq(result)
    end
  end

  describe '#dec_coin' do
    subject { bank.dec_coin(coin) }

    let(:coin) { OpenStruct.new({ id: 2, name: '3$', value: 3.00 }) }
    let(:result) do
      {
        1 => 1,
        2 => 0,
        3 => 2,
        4 => 3,
        5 => 0,
        6 => 3
      }
    end

    it { is_expected.to eq(0) }
    it 'changes bank' do
      subject
      expect(bank.bank).to eq(result)
    end
  end
end
