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
    context 'no filter' do
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
  end

  context 'filter by category' do
    context 'GET #index with real category id' do
      before do
        get_json '/api/projects', category_id: @project.category.id
      end

      it 'should have a valid status' do
        expect(response).to be_success
      end

      it 'responds with all the projects' do
        expect(parsed_body.keys.first).to eq('projects')
      end
    end
    context 'GET #index with invalid category id' do
      before do
        get_json '/api/projects', category_id: 0
      end

      it 'should have a valid status' do
        expect(response).to be_success
      end

      it 'should have no results' do
        expect(parsed_body['projects'].size).to eq(0)
      end
    end
  end

  context 'filtered by company' do
    context 'GET #index with company id' do
      before do
        get_json '/api/projects', company_id: @company.id
      end

      it 'should have a valid status' do
        expect(response).to be_success
      end

      it 'responds with all the projects' do
        expect(parsed_body.keys.first).to eq('projects')
      end
    end
    context 'GET #index with invalid company id' do
      before do
        get_json '/api/projects', company_id: 0
      end

      it 'should have a valid status' do
        expect(response).to be_success
      end

      it 'should have no results' do
        expect(parsed_body['projects'].size).to eq(0)
      end
    end
  end

  context 'GET #show' do
    context 'existing project' do
      before do
        get_json "/api/projects/#{@project.id}"
      end

      it 'should have a valid status' do
        expect(response).to be_success
      end

      it 'responds with all the projects' do
        expect(parsed_body.keys.first).to eq('project')
      end

      it 'should have the correct keys' do
        expect(parsed_body['project'].keys).to match_array(['category', 'city_ref', 'id', 'permits_count', 'title'])
      end
    end

    context 'invalid project id' do
      before do
        get_json '/api/projects/0'
      end

      it 'should have a valid status' do
        expect(response).to be_not_found
      end

      it 'responds with all the projects' do
        expect(parsed_body.keys.first).to eq('projects')
      end
    end
  end

end
