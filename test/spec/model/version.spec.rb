require 'rspec'
require 'model/version'

RSpec.describe Semble::Model::Version, '#new' do
  context 'with empty version passed' do
    it 'should read nothing' do
      version = Semble::Model::Version.new('')
      expect(version.major).to eq nil
      expect(version.minor).to eq nil
      expect(version.patch).to eq nil
      expect(version.build).to eq nil
      expect(version.classifier).to eq nil
    end
  end

  context 'with full version passed' do
    it 'should read full version' do
      version = Semble::Model::Version.new('1.2.3.4567-SNAPSHOT')
      expect(version.major).to eq 1
      expect(version.minor).to eq 2
      expect(version.patch).to eq 3
      expect(version.build).to eq 4567
      expect(version.classifier).to eq 'SNAPSHOT'
    end
  end

  context 'with classifier-only version passed' do
    it 'should not read anything but classifier' do
      classifier = 'classifier'
      version = Semble::Model::Version.new(classifier)
      expect(version.major).to eq nil
      expect(version.minor).to eq nil
      expect(version.patch).to eq nil
      expect(version.build).to eq nil
      expect(version.classifier).to eq classifier
    end
  end

  context 'with multi-classifier version passed' do
    it 'should read only up to classifier' do
      version = Semble::Model::Version.new('1.1-RC.1234')
      expect(version.major).to eq 1
      expect(version.minor).to eq 1
      expect(version.patch).to eq nil
      expect(version.build).to eq nil
      expect(version.classifier).to eq 'RC'
    end
  end
end

describe Semble::Model::Version, '#normalize' do
  context 'with empty version passed' do
    it 'should set all number zeros' do
      version = Semble::Model::Version.new('').normalize
      expect(version.major).to eq 0
      expect(version.minor).to eq 0
      expect(version.patch).to eq 0
      expect(version.build).to eq 0
      expect(version.classifier).to eq nil
    end
  end

  context 'with classifier set' do
    it 'should not alter classifier' do
      classifier = 'classifier'
      version = Semble::Model::Version.new("1.0-#{classifier}")
      expect(version.classifier).to eq classifier
      version = version.normalize
      expect(version.classifier).to eq classifier
    end
  end
end

describe Semble::Model::Version, '#<' do
  it 'should return true on valid comparison' do
    version_a = Semble::Model::Version.new('1.11-RC')
    version_b = Semble::Model::Version.new('1.12-RC')
    expect(version_a < version_b).to eq true
  end
  it 'should return false on equal versions' do
    version_a = Semble::Model::Version.new('1.11-RC')
    version_b = Semble::Model::Version.new('1.11-RC')
    expect(version_a < version_b).to eq false
  end
  it 'should return false on invalid comparison' do
    version_a = Semble::Model::Version.new('1.11-RC')
    version_b = Semble::Model::Version.new('1.12-RC')
    expect(version_b < version_a).to eq false
  end
end

describe Semble::Model::Version, '#>' do
  it 'should return true on valid comparison' do
    version_a = Semble::Model::Version.new('1.12-RC')
    version_b = Semble::Model::Version.new('1.11-RC')
    expect(version_a > version_b).to eq true
  end
  it 'should return false on equal versions' do
    version_a = Semble::Model::Version.new('1.11-RC')
    version_b = Semble::Model::Version.new('1.11-RC')
    expect(version_a > version_b).to eq false
  end
  it 'should return false on invalid comparison' do
    version_a = Semble::Model::Version.new('1.11-RC')
    version_b = Semble::Model::Version.new('1.12-RC')
    expect(version_a > version_b).to eq false
  end
end

describe Semble::Model::Version, '#==' do
  it 'should correctly test equality' do
    version_a = Semble::Model::Version.new('1.12-RC')
    version_b = Semble::Model::Version.new('1.12-RC')

    expect(version_a).to eq version_b
  end
end

describe Semble::Model::Version, '#<=>' do
  it 'should correctly sort versions' do
    version_a = Semble::Model::Version.new('1.12-RC')
    version_b = Semble::Model::Version.new('1.108.19.1234')
    version_c = Semble::Model::Version.new('1')

    versions = [
        version_a,
        version_b,
        version_c
    ]

    versions.sort!

    expect(versions[0]).to eq version_c
    expect(versions[1]).to eq version_a
    expect(versions[2]).to eq version_b
  end
end