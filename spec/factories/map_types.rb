FactoryGirl.define do

  sequence :title do |n|
    "Shoot Place #{n}"
  end

  factory :map_type do
    title
    association :address
  end

  factory :intersection, class: Intersection, parent: :map_type
  factory :street,       class: Street,       parent: :map_type
end
