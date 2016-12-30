require 'rspec'
require 'model/version'


describe Semble::Model::Version do
  def factory version
    Semble::Model::Version.new(version)
  end
  
  describe '#new' do
    context 'with empty version passed' do
      it 'should read nothing' do
        version = factory ''
        expect(version.major).to eq nil
        expect(version.minor).to eq nil
        expect(version.patch).to eq nil
        expect(version.build).to eq nil
        expect(version.classifier).to eq nil
      end
    end

    context 'with full version passed' do
      it 'should read full version' do
        version = factory '1.2.3.4567-SNAPSHOT'
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
        version = factory classifier
        expect(version.major).to eq nil
        expect(version.minor).to eq nil
        expect(version.patch).to eq nil
        expect(version.build).to eq nil
        expect(version.classifier).to eq classifier
      end
    end

    context 'with multi-classifier version passed' do
      it 'should read only up to classifier' do
        version = factory '1.1-RC.1234'
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
        version = factory('').normalize
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
        version = factory "1.0-#{classifier}"
        expect(version.classifier).to eq classifier
        version = version.normalize
        expect(version.classifier).to eq classifier
      end
    end
  end

  describe Semble::Model::Version, '#<' do
    it 'should return true on valid comparison' do
      version_a = factory '1.11-RC'
      version_b = factory '1.12-RC'
      expect(version_a < version_b).to eq true
    end
    it 'should return false on equal versions' do
      version_a = factory '1.11-RC'
      version_b = factory '1.11-RC'
      expect(version_a < version_b).to eq false
    end
    it 'should return false on invalid comparison' do
      version_a = factory '1.11-RC'
      version_b = factory '1.12-RC'
      expect(version_b < version_a).to eq false
    end
  end

  describe Semble::Model::Version, '#>' do
    it 'should return true on valid comparison' do
      version_a = factory '1.12-RC'
      version_b = factory '1.11-RC'
      expect(version_a > version_b).to eq true
    end
    it 'should return false on equal versions' do
      version_a = factory '1.11-RC'
      version_b = factory '1.11-RC'
      expect(version_a > version_b).to eq false
    end
    it 'should return false on invalid comparison' do
      version_a = factory '1.11-RC'
      version_b = factory '1.12-RC'
      expect(version_a > version_b).to eq false
    end
  end

  describe Semble::Model::Version, '#==' do
    it 'should correctly test equality' do
      version_a = factory '1.12-RC'
      version_b = factory '1.12-RC'

      expect(version_a).to eq version_b
    end
  end

  describe Semble::Model::Version, '#<=>' do
    it 'should correctly sort versions' do
      version_a = factory '1.12-RC'
      version_b = factory '1.108.19.1234'
      version_c = factory '1'

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

  describe Semble::Model::Version, '#shorten' do
    context 'with classifier present' do
      it 'should strip it first off full version' do
        version = factory '1.0.12.1234-RC'
        expected = factory '1.0.12.1234'
        expect(version.shorten).to eq expected
      end

      it 'should strip it first off not so full version' do
        version = factory '1.0-RC'
        expected = factory '1.0'
        expect(version.shorten).to eq expected
      end
    end

    context 'with no classifier' do
      it 'should strip build version first' do
        version = factory '1.0.0.0'
        expected = factory '1.0.0'
        expect(version.shorten).to eq expected
      end

      it 'should strip patch version after stripping build version' do
        version = factory '1.0.0'
        expected = factory '1.0'
        expect(version.shorten).to eq expected
      end

      it 'should continue with minor version' do
        version = factory '1.0'
        expected = factory '1'
        expect(version.shorten).to eq expected
      end

      it 'should finish off major version after that' do
        version = factory '1'
        expected = factory ''
        expect(version.shorten).to eq expected
      end

      it 'should return null when everything has been stripped' do
        version = factory ''
        expect(version.shorten).to be_nil
      end
    end
  end
end