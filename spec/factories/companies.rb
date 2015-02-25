FactoryGirl.define do
  factory :company do
    name 'Warner Brothers Entertainment'

    trait :commainc do
      name 'Warner Brothers Entertainment, Inc'
    end

    trait :inc do
      name 'Warner Brothers Entertainment Inc'
    end

    trait :commallc do
      name 'Warner Brothers Entertainment, LLC'
    end

    trait :llc do
      name 'Warner Brothers Entertainment LLC'
    end
  end
end
