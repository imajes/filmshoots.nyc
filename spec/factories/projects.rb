FactoryGirl.define do
  factory :project do
    city_ref 1
    title   'Gossip Girl Fall 2011'

    company  {Company.first || FactoryGirl.create(:company) }
    category {Category.first || FactoryGirl.create(:category) }

  end
end

