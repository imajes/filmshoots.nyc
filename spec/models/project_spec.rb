require 'rails_helper'

RSpec.describe Project, type: :model do

  let(:project) { FactoryGirl.build_stubbed(:project) }

  context 'basic assumptions' do
    it 'should be valid' do
      expect(project).to be_valid
    end

    it 'should have a company, category and permits' do
      expect(project.company).to be_a_kind_of(Company)
      expect(project.category).to be_a_kind_of(Category)
      expect(project.permits).to eq([])
    end

    context 'city_ref' do

      before do
        Project.create!(city_ref: 'abc')
      end

      it 'should not permit a dupe ref' do
        expect(Project.new(city_ref: 'abc')).not_to be_valid
      end
    end
  end

  context 'importing' do

    let(:import) { described_class.import('abc', 'new project', 'my co', 'television') }

    it 'should create a category' do
      import
      expect(Category.find_by(name: 'television')).not_to be_nil
    end

    context 'company_import' do
      before do
        expect_any_instance_of(ImportCompanyService).to receive(:process!)
      end

      it 'should call the company service' do
        import
      end
    end

    it 'should save all the relevant attributes' do
      project = import
      expect(project).to be_a_kind_of(Project)
      expect(project).to be_valid
    end


    context 'duplicates' do
      before do
        import # run first time
      end

      it 'should not create another category' do
        expect { import }.not_to change { Category.count }
      end

    end
  end

  context 'all_locations'

end
