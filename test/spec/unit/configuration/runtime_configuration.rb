require 'rspec'
require_relative '../../../../lib/configuration/runtime_configuration'

describe Semble::Configuration::RuntimeConfiguration do
  def factory(*configurations)
    Semble::Configuration::RuntimeConfiguration.new(*configurations)
  end

  factory.property_list.each do |property|
    describe "##{property}" do
      it 'should be present and accessible' do
        instance = factory
        expect(instance).send(property).to be_nil
        instance.send(:"#{property}=", 12)
        expect(instance).send(property).to eq 12
      end
    end
  end
end
