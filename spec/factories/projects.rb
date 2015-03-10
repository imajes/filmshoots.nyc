FactoryGirl.define do
  factory :project do
    city_ref 1
    title   'Gossip Girl Fall 2011'

    association :company
    association :category

  end
end
