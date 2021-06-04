# frozen_string_literal: true

class Screen
  MENU_OPTIONS = [
    { name: 'Vend', value: 1 },
    { name: 'View warehouse', value: 2 },
    { name: 'View bank', value: 3 },
    { name: 'Quit', value: nil }
  ].freeze

  BACK_OPTIONS = [
    { name: 'Back', value: nil }
  ].freeze

  def initialize
    @prompt = TTY::Prompt.new
  end

  def table(headers:, rows:)
    table = TTY::Table.new(headers, rows)

    puts table.render(:ascii)
  end

  def select_options(question, list_options, back_option: false)
    prompt.select(question, back_option ? list_options + BACK_OPTIONS : list_options)
  end

  def info(message)
    prompt.ok(message)
  end

  def error(message)
    prompt.error(message)
  end

  def warn(message)
    prompt.warn(message)
  end

  private

  attr_reader :prompt
end
