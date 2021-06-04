# frozen_string_literal: true

class Bank
  COINS = [
    OpenStruct.new({ id: 1, name: '5$', value: 5.00 }),
    OpenStruct.new({ id: 2, name: '3$', value: 3.00 }),
    OpenStruct.new({ id: 3, name: '2$', value: 2.00 }),
    OpenStruct.new({ id: 4, name: '1$', value: 1.00 }),
    OpenStruct.new({ id: 5, name: '50c', value: 0.50 }),
    OpenStruct.new({ id: 6, name: '25c', value: 0.25 })
  ].freeze

  def initialize
    @bank = collection
  end

  def list_of_coins
    @list_of_coins ||= COINS.map { |item| { name: item.name, value: item.id } }
  end

  def coins_count
    COINS.map { |item| [item.name, bank.fetch(item.id)] }
  end

  def find(id)
    COINS.detect { |item| item.id == id }
  end

  def inc_coin(coin)
    bank[coin.id] += 1
  end

  def dec_coin(coin)
    bank[coin.id] -= 1
  end

  def available_coins(change)
    COINS.inject({}) do |res, coin|
      if bank[coin.id].positive? && coin.value <= change
        res.merge(coin.id => bank[coin.id])
      else
        res
      end
    end
  end

  private

  attr_reader :bank

  def collection
    COINS.inject({}) { |res, item| res.merge(item.id => rand(0..3)) }
  end
end
