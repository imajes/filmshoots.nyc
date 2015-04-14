require 'rails_helper'

RSpec.describe GeocodeAddressJob, type: :job do

  subject { described_class.new }

  context '#perform' do
    pending 'examples for perform'
  end

  context '#over_query_limit?' do

    context 'where over limit' do
      before do
        Sidekiq.redis { |x| x.set('geocoder_over_query_limit', 'true') }
      end

      it 'should report correctly' do
        expect { subject.over_query_limit? }.to raise_error(Geocoder::OverQueryLimitError)
      end
    end

    context 'where not overlimit yet' do
      before do
        Sidekiq.redis { |x| x.del('geocoder_over_query_limit') }
      end

      it 'should report correctly' do
        expect { subject.over_query_limit? }.not_to raise_error
      end
    end
  end

  context '#reached_limit!' do
    before do
      Sidekiq.redis { |x| x.del('geocoder_over_query_limit') }
      subject.reached_limit!
    end

    it 'should set the limit' do
      exists = Sidekiq.redis { |x| x.exists('geocoder_over_query_limit') }
      expect(exists).to eq(true)
    end

    it 'should set the expiry' do
      ttl = Sidekiq.redis { |x| x.ttl('geocoder_over_query_limit') }
      expect(ttl).to be_within(3).of(21600)
    end
  end
end
