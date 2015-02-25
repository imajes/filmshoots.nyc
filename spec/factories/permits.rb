FactoryGirl.define do
  factory :permit do
    event_ref 123
    event_name 'Washington Park Shoot'
    event_type 'Shooting Permit'
    event_start  { 10.days.ago }
    event_end   {  7.days.ago }
    entered_on  { 12.days.ago }

    trait :complete_location do
      original_location  'Monsignor McGolrick Park: Monsignor McGolrick Park  , REVIEW AVENUE  between 35 STREET and BORDEN AVENUE,  REVIEW AVENUE  between 35 STREET and BORDEN AVENUE,  STARR AVENUE  between VAN DAM STREET and BORDEN AVENUE, Silvercup Studios East: 34-02 Starr Avenue  , NORTH HENRY STREET  between NASSAU AVENUE and NORMAN AVENUE,  RUSSELL STREET  between NASSAU AVENUE and DRIGGS AVENUE,  NASSAU AVENUE  between HUMBOLDT STREET and RUSSELL STREET,  RUSSELL STREET  between NASSAU AVENUE and NORMAN AVENUE'
      zip                '11101, 11222'
      boro               'Brooklyn'
    end

    trait :nulls do
      zip 'NULL'
      boro 'NULL'
    end
  end
end
