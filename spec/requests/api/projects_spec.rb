require 'rails_helper'

RSpec.describe 'API :: Projects', type: :request do

  before(:all) do
    @company = FactoryGirl.create(:company)
    @project = FactoryGirl.create(:project, company: @company)
  end

  after(:all) do
    @company.destroy
    @project.category.destroy
    @project.destroy
  end

  context 'GET #index' do
    before do
      get_json '/api/projects'
    end

    it 'should have a valid status' do
      expect(response).to be_success
    end

    it 'responds with all the projects' do
      expect(parsed_body.keys.first).to eq('projects')
    end

    it 'should have the correct keys' do
      expect(parsed_body['projects'].first.keys).to match_array(['category', 'city_ref', 'id', 'permits_count', 'title'])
    end
  end

  context 'GET #index with category name' do
    before do
      get_json '/api/projects', category_name: @project.category.name
    end

    it 'should have a valid status' do
      expect(response).to be_success
    end

    it 'responds with all the projects' do
      expect(parsed_body.keys.first).to eq('projects')
    end

    it 'should have the correct keys' do
      expect(parsed_body['projects'].first.keys).to match_array(['category', 'city_ref', 'id', 'permits_count', 'title'])
    end
  end
end
