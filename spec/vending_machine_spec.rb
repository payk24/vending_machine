# frozen_string_literal: true

require 'spec_helper'

describe VendingMachine do
  describe '#call' do
    subject { vending_machine.call }

    let(:vending_machine) { VendingMachine.new }
    let(:screen_instance) { instance_double(Screen) }
    let(:vend_handler_instance) { instance_double(VendHandler, call: true) }

    before do
      allow(Screen).to receive(:new) { screen_instance }
      allow(screen_instance).to receive(:select_options) { select_option }
      allow(screen_instance).to receive(:table)
      allow(VendHandler).to receive(:new) { vend_handler_instance }
      allow(vend_handler_instance).to receive(:call)
      allow(vending_machine).to receive(:loop).and_yield
    end

    context 'when select option is 1' do
      let(:select_option) { 1 }

      it 'calls VendHandler' do
        subject
        expect(VendHandler).to have_received(:new)
      end
    end

    context 'when select option is 2' do
      let(:select_option) { 2 }

      it 'calls screen table' do
        subject
        expect(screen_instance).to have_received(:table)
      end
    end

    context 'when select option is 3' do
      let(:select_option) { 3 }

      it 'calls screen table' do
        subject
        expect(screen_instance).to have_received(:table)
      end
    end
  end
end
