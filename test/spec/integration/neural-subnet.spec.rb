require 'fileutils'
require 'rspec'
require_relative '../../helper/diffable_directory'

RSpec.describe Semble, 'cli' do
  context 'with neural-subnet example' do
    it 'should create tree identical to expected' do
      expected_tree = Pathname.new(__dir__).join('resources/neural-subnet/expected')
      built_tree = Pathname.new(__dir__).join('resources/neural-subnet/build')
      Dir.glob(built_tree.to_s + '/**/*').each do |path|
        File.delete(path) unless File.directory?(path)
      end
      binary = Pathname(__dir__).join('../../../bin/semble').cleanpath
      configuration = Pathname(__dir__).join('resources/neural-subnet/semble.yml')
      command = sprintf('"%s" -c "%s"', binary, configuration)
      system(command)

      expected_matcher = Semble::Test::DiffableDirectory.new(expected_tree)
      built_matcher =  Semble::Test::DiffableDirectory.new(built_tree)

      expect(expected_matcher.diff(built_matcher)).to eq({})
    end
  end
end