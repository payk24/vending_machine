# frozen_string_literal: true

require 'spec_helper'

describe Screen do
  let(:screen) { Screen.new }
  let(:prompt_instance) { instance_double(TTY::Prompt, ok: true, error: true, warn: true, select: true) }
  let(:table_instance) { instance_double(TTY::Table, render: true) }

  before do
    allow_any_instance_of(Screen).to receive(:prompt) { prompt_instance }
    allow(TTY::Table).to receive(:new) { table_instance }
    allow(table_instance).to receive(:render)
  end

  describe '#info' do
    subject { screen.info(message) }

    let(:message) { 'foo' }

    it 'calls ok' do
      subject
      expect(prompt_instance).to have_received(:ok).with(message)
    end
  end

  describe '#error' do
    subject { screen.error(message) }

    let(:message) { 'foo' }

    it 'calls error' do
      subject
      expect(prompt_instance).to have_received(:error).with(message)
    end
  end

  describe '#warn' do
    subject { screen.warn(message) }

    let(:message) { 'foo' }

    it 'calls warn' do
      subject
      expect(prompt_instance).to have_received(:warn).with(message)
    end
  end

  describe '#table' do
    subject { screen.table(headers: headers, rows: rows) }

    let(:headers) { ['foo'] }
    let(:rows) { ['bar'] }

    it 'renders table' do
      subject
      expect(TTY::Table).to have_received(:new).with(headers, rows)
      expect(table_instance).to have_received(:render).with(:ascii)
    end
  end

  describe '#select_options' do
    subject { screen.select_options(question, list_options, back_option: back_option) }

    let(:question) { 'foo' }
    let(:list_options) { ['bar'] }
    let(:back_option) { false }

    it 'calls select' do
      subject
      expect(prompt_instance).to have_received(:select).with(question, list_options)
    end

    context 'when back_option is true' do
      let(:back_option) { true }

      it 'calls select' do
        subject
        expect(prompt_instance).to have_received(:select).with(question, list_options + Screen::BACK_OPTIONS)
      end
    end
  end
end
