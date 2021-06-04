# frozen_string_literal: true

require 'tty-prompt'
require 'tty-table'
require 'ostruct'

require './lib/screen'
require './lib/warehouse'
require './lib/bank'
require './lib/vend_handler'
require './lib/change_coin_processor'

class VendingMachine
  MENU_OPTIONS = [
    { name: 'Vend', value: 1 },
    { name: 'View warehouse', value: 2 },
    { name: 'View bank', value: 3 },
    { name: 'Quit', value: nil }
  ].freeze

  def initialize
    @screen = Screen.new
    @bank = Bank.new
    @warehouse = Warehouse.new
  end

  def call
    loop do
      case menu
      when 1
        vend
      when 2
        warehouse_table
      when 3
        bank_table
      else
        exit
      end
    end
  end

  private

  attr_reader :screen, :bank, :warehouse

  def menu
    screen.select_options('Chose a mode', MENU_OPTIONS)
  end

  def vend
    VendHandler.new(screen, bank, warehouse).call
  end

  def warehouse_table
    screen.table(headers: [' Product ', ' Quantity '], rows: warehouse.products_count)
  end

  def bank_table
    screen.table(headers: [' Coin ', ' Quantity '], rows: bank.coins_count)
  end
end
