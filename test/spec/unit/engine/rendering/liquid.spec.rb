require 'rspec'
require 'engine/rendering/liquid'

describe Semble::Engine::Rendering::Liquid, '#render' do
  def factory
    Semble::Engine::Rendering::Liquid.new
  end

  context 'with invalid template syntax' do
    it 'should raise an exception' do
      template = '{% if boolean %}{{ string }}'
      context = {boolean: true, string: 'This is a test string'}

      expect { factory.render(template, context) }.to raise_exception
    end
  end

  context 'with missing template variable' do
    it 'should raise an exception' do
      template = '{% if boolean %}{{ string }}{% endif %}'
      context = {boolean: true}

      expect { factory.render(template, context) }.to raise_exception
    end
  end

  context 'with valid template syntax and all template variables' do
    it 'should successfully render template' do
      template = '{% if boolean %}{{ string }}{% endif %}'
      context = {boolean: true, string: 'This is a test string'}

      expect { factory.render(template, context) }.to_not raise_exception
    end
  end
end