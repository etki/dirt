require 'rspec'
require 'engine/image_builder'
require 'model/version_specification'
require 'model/version'
require 'pathname'

def factory
  Semble::Engine::ImageBuilder.new
end

def spec_factory(&block)
  Semble::Model::VersionSpecification.new(&block)
end

def version_factory(version)
  Semble::Model::Version.new(version)
end

RSpec.describe Semble::Engine::ImageBuilder, '#build' do
  context 'with empty array on input' do
    it 'should return empty image' do
      platform = :debian
      version = version_factory '0.1.0'
      image = factory.build([], platform, version)
      expect(image.platform).to eq platform
      expect(image.version).to eq version
      expect(image.sources).to eq ({})
      expect(image.context).to eq ({})
    end
  end

  context 'with single version specification' do
    it 'should copy it' do
      spec = spec_factory do |spec|
        spec.platform = :debian
        spec.version = version_factory '0.1.0'
        spec.sources = {}
      end

      result = factory.build([spec], :debian, version_factory('0.1.0'))

      expect(result.platform).to eq spec.platform
      expect(result.version).to eq spec.version
      expect(result.sources).to eq spec.sources
      expect(result.context).to eq spec.context
    end
  end

  context 'with several versions' do
    it 'should combine them' do
      spec_a = spec_factory do |spec|
        spec.platform = :debian
        spec.version = version_factory '0.1.0'
        spec.sources = {Pathname.new('/file-a') => {version: '0.1.0'}}
        spec.context = {version: '0.1.0', nested: {x: 1, y: 3}}
      end

      spec_b = spec_factory do |spec|
        spec.platform = :debian
        spec.version = version_factory '0.1.1'
        spec.sources = {Pathname.new('/file-b') => {version: '0.1.1'}}
        spec.context = {version: '0.1.1', nested: {x: 12}, remark: 'nothing'}
      end

      spec_c = spec_factory do |spec|
        spec.platform = :debian
        spec.version = version_factory '0.1.2'
        spec.sources = {Pathname.new('/file-b') => {version: '0.1.2'}}
        spec.context = {version: '0.1.2', nested: {}}
      end

      expected = spec_factory do |spec|
        spec.platform = :debian
        spec.version = version_factory '0.1.2'
        spec.sources = {Pathname.new('/file-a') => {version: '0.1.0'}, Pathname.new('/file-b') => {version: '0.1.2'}}
        spec.context = {version: '0.1.2', nested: {x: 12, y: 3}, remark: 'nothing'}
      end
      
      result = factory.build([spec_a, spec_b, spec_c], :debian, version_factory('0.1.2'))
      expect(result.platform).to eq expected.platform
      expect(result.version).to eq expected.version
      expect(result.sources).to eq expected.sources
      expect(result.context).to eq expected.context
    end
  end

  context 'with no version and platform specified' do
    it 'should fetch them from last version' do
      expected_platform = :debian
      expected_version = version_factory '1.1.1'
      versions = [
          spec_factory do |spec|
            spec.platform = :alpine
            spec.version = version_factory '1.0.0'
          end,
          spec_factory do |spec|
            spec.platform = :alpine
            spec.version = version_factory '1.0.1'
          end,
          spec_factory do |spec|
            spec.platform = expected_platform
            spec.version = expected_version
          end,
      ]

      image = factory.build versions
      expect(image.platform).to eq expected_platform
      expect(image.version).to eq expected_version
    end
  end
end