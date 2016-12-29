require 'rspec'
require 'model/image_request'
require 'model/version'

def from_string(input)
  Semble::Model::ImageRequest.from_string(input)
end

RSpec.describe Semble::Model::ImageRequest, '#from_string' do
  context 'with an input without colons' do
    it 'should treat whole input as version' do
      request = from_string('0.1.0')
      expect(request.platform).to be_nil
      expect(request.version).to eq Semble::Model::Version.new('0.1.0')
    end
  end

  context 'with a colon-delimited input' do
    it 'should treat part before first colon as platform, other as version' do
      request = from_string('platform:0.1.0')
      expect(request.platform).to eq 'platform'
      expect(request.version).to eq Semble::Model::Version.new('0.1.0')
    end
  end

  context 'with extra spaces in input' do
    it 'should not include them in platform and/or version' do
      request = from_string(' platform : 0.1.0 ')
      expect(request.platform).to eq 'platform'
      expect(request.version).to eq Semble::Model::Version.new('0.1.0')
    end
  end
end