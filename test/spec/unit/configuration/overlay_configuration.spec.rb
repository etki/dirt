require 'rspec'
require_relative '../../../../lib/configuration/overlay_configuration'

def factory(*configurations)
  Semble::Configuration::OverlayConfiguration.new(*configurations)
end

describe Semble::Configuration::OverlayConfiguration do

  factory.property_list.each do |property|
    klass = Class.new do
      def initialize(value = nil)
        @value = value
      end
      define_method property do
        @value
      end
    end
    describe "##{property}" do
      context 'with no configuration fed in' do
        it 'should return nil' do
          expect(factory.send(property)).to be_nil
        end
      end
      context 'with empty configurations fed in' do
        it 'should return nil' do
          expect(factory(klass.new, klass.new).send(property)).to be_nil
        end
      end
      context 'with empty configurations and non-empty last configuration fed in' do
        it 'should return last configuration value' do
          expect(factory(klass.new, klass.new, klass.new(12))).send(property).to eq 12
        end
      end
      context 'with multiple non-empty configurations' do
        it 'should return first non-null value' do
          expect(factory(klass.new, klass.new(12), klass.new(13))).send(property).to eq 12
        end
      end
    end
  end
end
