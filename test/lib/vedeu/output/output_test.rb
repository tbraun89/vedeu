require_relative '../../../test_helper'

module Vedeu
  describe Output do
    let(:described_class) { Output }
    let(:subject)         { described_class.new }

    before do
      Interface.create({ name: 'dummy', width: 15, height: 2, cursor: true })
    end

    after { InterfaceRepository.reset }

    it 'returns an Output instance' do
      subject.must_be_instance_of(Output)
    end

    describe '.render' do
      let(:subject) { described_class.render }
    end
  end
end
