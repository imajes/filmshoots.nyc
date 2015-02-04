require 'rails_helper'
require 'location_parser'


RSpec.describe LocationParser, type: :lib do

  location_samples = YAML.load_file(Rails.root.join('spec/locations.yml'))


  RSpec.shared_examples 'prepared strings' do |locations|

    locations.keys.each do |test|

      let(:original) { locations[test]['original'] }
      let(:converted) { locations[test]['converted'] }

      it "should translate '#{test.humanize}' accurately" do
        expect(described_class.prepare(original)).to eq(converted)
      end

    end
  end


  it_behaves_like 'prepared strings', location_samples

end
