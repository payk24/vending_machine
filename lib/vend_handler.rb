# frozen_string_literal: true

class VendHandler
  LARGE_NAMBER = 10

  def initialize(screen, bank, warehouse)
    @screen = screen
    @bank = bank
    @warehouse = warehouse
  end

  def call
    product = select_product

    return if product.nil?
    return screen.error('Current product is out of stock') unless warehouse.available?(product)

    screen.info("Selected #{product.name}, please deposit #{product.price}$")

    deposit_coins = insert_deposit(product)
    change = sum_deposit_coins(deposit_coins) - product.price
    change_coins = ChangeCoinProcessor.new(bank, change).call

    if change.positive? && change_coins.nil?
      return screen.error('Sorry, we can\'t prepare change for this amount. Take your money!')
    end

    product_purchase(product, deposit_coins, change_coins)

    screen.info("Here is your: #{product.name}")

    return if change.zero?

    screen.info("And your change of #{change}$, coins: #{decorate_change_coins_result(change_coins)}")
  end

  private

  attr_reader :screen, :bank, :warehouse

  def select_product
    warehouse.find(screen.select_options('Select product', warehouse.list_of_products, back_option: true))
  end

  def insert_deposit(product)
    deposit_coins = []

    until sum_deposit_coins(deposit_coins) >= product.price
      screen.warn("Left to deposit #{product.price - sum_deposit_coins(deposit_coins)}$") unless deposit_coins.empty?
      deposit_coins.push(bank.find(screen.select_options('Deposit coins', bank.list_of_coins)))
    end

    deposit_coins
  end

  def sum_deposit_coins(deposit)
    deposit.sum(&:value)
  end

  def product_purchase(product, deposit_coins, change_coins)
    warehouse.dec_product(product)
    deposit_coins.each { |coin| bank.inc_coin(coin) }
    change_coins.each do |coin_id, count|
      coin = bank.find(coin_id)
      1.upto(count) { bank.dec_coin(coin) }
    end
  end

  def decorate_change_coins_result(change_coins)
    change_coins.map { |coin_id, count| "#{bank.find(coin_id).name} - #{count} pcs" }.join(', ')
  end
end
