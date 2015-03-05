require 'rails_helper'

RSpec.describe "Lint" do
  it "FactoryGirl" do
    DatabaseCleaner.cleaning do
      FactoryGirl.lint
    end
  end
end
