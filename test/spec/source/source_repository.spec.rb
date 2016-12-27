require 'source/source_repository'
require 'source/layer'
require 'semantic'

RSpec.describe Semble::Source::SourceRepository, '#get_platform_versions' do

  init = lambda do |*layers|
    repository = Semble::Source::SourceRepository.new
    layers.each { |layer| repository.push(layer) }
    repository
  end

  context 'with two matching and one non-matching source lists' do
    it 'should return only two source lists in correct order' do
      version_a = Semble::Model::Version.new('1.3.8')
      version_b = Semble::Model::Version.new('1.4.2')
      version_c = Semble::Model::Version.new('1.4.5')
      layers = [
          Semble::Source::Layer.new do |layer|
            layer.set_version(version_a)
            layer.platform = :debian
          end,
          Semble::Source::Layer.new do |layer|
            layer.set_version(version_b)
            layer.platform = :alpine
          end,
          Semble::Source::Layer.new do |layer|
            layer.set_version(version_c)
            layer.platform = :debian
          end,
      ]
      repository = init.call(*layers)

      versions = repository.get_slice(:debian, version_c)
      expect(versions.size).to eq 2
      expect(versions.to_a.at(0).version).to eq version_a
      expect(versions.to_a.at(1).version).to eq version_c
    end
  end
end