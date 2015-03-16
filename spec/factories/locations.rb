FactoryGirl.define do
  factory :location, class: Location, parent: :map_type do
    after(:build) do |loc|
      loc.intersections = [FactoryGirl.build(:intersection)]
    end
  end
end
