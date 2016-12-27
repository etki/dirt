require 'rendering/context_builder'

RSpec.describe Semble::Rendering::ContextBuilder, '#merge' do
  context 'with two values, at least one of which is not hash' do
    it 'should return second value' do
      builder = Semble::Rendering::ContextBuilder.new

      expect(builder.merge(1, 2)).to eq 2
      expect(builder.merge('test', {x: true})).to eq ({x: true})
      expect(builder.merge({x: true}, 'test')).to eq 'test'
      expect(builder.merge({x: true}, nil)).to eq nil
    end
  end

  context 'with two hashes' do
    it 'should perform overrides using second hash keys' do
      builder = Semble::Rendering::ContextBuilder.new

      hash_a = {x: 12, y: 13}
      hash_b = {y: 55, z: 66}
      expected = {x: 12, y: 55, z: 66}

      expect(builder.merge(hash_a, hash_b)). to eq expected
    end
  end
end