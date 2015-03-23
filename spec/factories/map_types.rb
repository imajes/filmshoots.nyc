FactoryGirl.define do

  sequence :title do |n|
    "Shoot Place #{n}"
  end

  factory :map_type do
    title
    original_address '27 WALL STREET, Manhattan, NY, 10005'

    # after(:build) do |mt|
    #   mt.address = Address.first || FactoryGirl.build(:address, original: '27 WALL STREET, Manhattan, NY, 10005')
    # end
  end

  factory :intersection, class: Intersection, parent: :map_type
  factory :street,       class: Street,       parent: :map_type
end
