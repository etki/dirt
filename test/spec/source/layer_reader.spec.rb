require 'source/layer_reader'
require 'fileutils'
require 'rspec/expectations'
require 'pathname'

# todo: implement all operations via virtual file system

RSpec.describe Semble::Source::LayerReader, '#read' do

  temporary_directory = nil

  before(:each) do
    temporary_directory = Dir.mktmpdir('semble-testing-')
  end

  after(:each) do
    FileUtils.rm_r(temporary_directory)
  end

  put_file = lambda do |path, content = ''|
    full_path = File.join(temporary_directory, path)
    FileUtils.makedirs(File.dirname(full_path))
    File.open(full_path, 'w') do |handle|
      handle.write(content)
    end
  end

  read = lambda do |path|
    Semble::Source::LayerReader.new.read(temporary_directory, '_default', Semble::Model::Version.new('1.0.0'))
  end

  context 'with directory of one .liquid file' do
    it 'should return layer with one template entry' do
      path = 'etc/neural-subnet/configuration.yml'
      put_file.call("#{path}.liquid")
      layer = read.call(temporary_directory)
      expect(layer.sources).to include(Pathname.new(temporary_directory))
      expect(layer.entries.length).to eq 1
      expect(layer.entries.values.first.path.to_s).to end_with(path)
      expect(layer.entries.values.first.type).to eq :template
      expect(layer.whiteouts).to be_empty
    end
  end

  context 'with directory of one regular file' do
    it 'should return layer with one regular entry' do
      path = 'etc/neural-subnet/configuration.yml'
      put_file.call(path)
      layer = read.call(temporary_directory)
      expect(layer.sources).to include(Pathname.new(temporary_directory))
      expect(layer.entries.length).to eq 1
      expect(layer.entries.values.first.path.to_s).to end_with(path)
      expect(layer.entries.values.first.type).to eq :unknown
      expect(layer.whiteouts).to be_empty
    end
  end

  context 'with directory of one whiteout file' do
    it 'should return layer with one whiteout' do
      path = 'etc/neural-subnet/.wh.configuration.yml'
      expected = Pathname.new('etc/neural-subnet/configuration.yml')
      put_file.call(path)
      layer = read.call(temporary_directory)
      expect(layer.sources).to include(Pathname.new(temporary_directory))
      expect(layer.entries).to be_empty
      expect(layer.whiteouts.length).to eq 1
      expect(layer.whiteouts.first).to eq expected
    end
  end
end