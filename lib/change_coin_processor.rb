# frozen_string_literal: true

class ChangeCoinProcessor
  MIN_NAMBER = Bank::COINS.map(&:value).min
  MAX_NAMBER = Bank::COINS.map(&:value).max * 2

  def initialize(bank, change)
    @bank = bank
    @change = change
    @available_coins = bank.available_coins(change)
    @min_count_coins = {}
    @unused_coins = {}
  end

  def call
    (MIN_NAMBER..change).step(MIN_NAMBER) { |amount| min_coins(amount) }
    return if min_count_coins[change] == MAX_NAMBER

    used_coins
  end

  private

  attr_reader :bank, :change, :available_coins
  attr_accessor :min_count_coins, :unused_coins

  def min_coins(amount)
    min_count_coins[amount] = MAX_NAMBER

    available_coins.each do |coin_id, _|
      coin = bank.find(coin_id)
      amount_coin = amount - coin.value
      supposed_min_count = (min_count_coins[amount_coin] || 0) + 1

      next unless amount_coin >= 0 &&
                  (unused_coins[amount_coin].nil? || unused_coins.dig(amount_coin, coin.id)&.positive?) &&
                  supposed_min_count < min_count_coins[amount]

      min_count_coins[amount] = supposed_min_count
      avl_coins = unused_coins[amount_coin] || available_coins
      unused_coins[amount] = avl_coins.merge(coin.id => avl_coins[coin.id] - 1)
    end
  end

  def used_coins
    available_coins.inject({}) do |res, (coin_id, count)|
      res.merge(coin_id => (count - unused_coins.dig(change, coin_id)))
    end.select { |_, v| v.positive? }
  end
end
