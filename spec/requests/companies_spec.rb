require 'rails_helper'

RSpec.describe 'API :: Companies', type: :request do

  before(:all) do
    @company = FactoryGirl.create(:company)
    @category = FactoryGirl.create(:category)
  end

  after(:all) do
    @company.destroy
    @category.destroy
  end

  context 'GET #index' do

    before do
      json_get '/api/companies'
    end

    it 'should have a valid status' do
      expect(response).to be_success
    end

    it 'responds with all the companies' do
      expect(parsed_body.keys.first).to eq('companies')
    end

    it 'should have the correct keys' do
      expect(parsed_body['companies'].first.keys).to match_array(['name', 'projects_count'])
    end
  end

end
