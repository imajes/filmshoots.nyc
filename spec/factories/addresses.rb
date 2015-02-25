FactoryGirl.define do
  factory :address do
        original '26 WALL STREET, Manhattan, NY 10005'
       formatted '26 Wall Street, New York, NY 10005, USA'
         zipcode '10005'
    neighborhood 'Lower Manhattan'
        latitude 40.707258
       longitude -74.0103564
            data "{\"address_components\":[{\"long_name\":\"26\",\"short_name\":\"26\",\"types\":[\"street_number\"]},{\"long_name\":\"Wall Street\",\"short_name\":\"Wall St\",\"types\":[\"route\"]},{\"long_name\":\"Lower Manhattan\",\"short_name\":\"Lower Manhattan\",\"types\":[\"neighborhood\",\"political\"]},{\"long_name\":\"Manhattan\",\"short_name\":\"Manhattan\",\"types\":[\"sublocality_level_1\",\"sublocality\",\"political\"]},{\"long_name\":\"New York\",\"short_name\":\"New York\",\"types\":[\"locality\",\"political\"]},{\"long_name\":\"New York County\",\"short_name\":\"New York County\",\"types\":[\"administrative_area_level_2\",\"political\"]},{\"long_name\":\"New York\",\"short_name\":\"NY\",\"types\":[\"administrative_area_level_1\",\"political\"]},{\"long_name\":\"United States\",\"short_name\":\"US\",\"types\":[\"country\",\"political\"]},{\"long_name\":\"10005\",\"short_name\":\"10005\",\"types\":[\"postal_code\"]}],\"formatted_address\":\"26 Wall Street, New York, NY 10005, USA\",\"geometry\":{\"location\":{\"lat\":40.707258,\"lng\":-74.01035639999999},\"location_type\":\"ROOFTOP\",\"viewport\":{\"northeast\":{\"lat\":40.7086069802915,\"lng\":-74.00900741970848},\"southwest\":{\"lat\":40.7059090197085,\"lng\":-74.01170538029149}}},\"types\":[\"street_address\"]}"
        geocoded true
  end
end
