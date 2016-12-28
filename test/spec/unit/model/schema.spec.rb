require 'rspec'
require 'model/schema'
require 'model/version'
require 'model/version_specification'

RSpec.describe Semble::Model::Schema, '#get_slice' do

  def factory
    Semble::Model::Schema.new
  end

  def spec_factory(platform, version)
    Semble::Model::VersionSpecification.new do |spec|
      spec.version = version_factory(version)
      spec.platform = platform
    end
  end

  def version_factory(version)
    Semble::Model::Version.new(version)
  end

  context 'having empty platform' do
    it 'should return empty array' do
      schema = factory

      expect(schema.get_slice(:debian, version_factory('0.0.0'))).to eq []
    end
  end

  context 'having unmatching platform versions' do
    it 'should return empty array' do
      schema = factory
      versions = [
          spec_factory(:debian, '1.2.3'),
          spec_factory(:debian, '1.3.5'),
          spec_factory(:debian, '1.4.7')
      ]
      versions.each do |v|
        schema.add_version(v)
      end

      expect(schema.get_slice(:debian, version_factory('1.2.2'))).to eq []
    end
  end

  context 'having all matching platform versions' do
    it 'should return everything' do
      schema = factory
      versions = [
          spec_factory(:debian, '1.2.3'),
          spec_factory(:debian, '1.3.5'),
          spec_factory(:debian, '1.4.7')
      ]
      versions.each do |v|
        schema.add_version(v)
      end

      expect(schema.get_slice(:debian, version_factory('1.4.7'))).to eq versions
    end
  end

  context 'having matching and unmatching platform versions' do
    it 'should correctly slice' do
      schema = factory
      versions = [
          spec_factory(:debian, '1.2.3'),
          spec_factory(:debian, '1.3.5'),
          spec_factory(:debian, '1.4.7')
      ]
      versions.each do |v|
        schema.add_version(v)
      end

      expect(schema.get_slice(:debian, version_factory('1.3.5'))).to eq versions.slice(0, 2)
    end
  end
end