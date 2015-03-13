require 'rails_helper'
RSpec.describe ApplicationHelper, type: :helper do

  it 'should return the length of a shoot' do

    Timecop.freeze('2015-03-13'.to_date) do
      @text = helper.shoot_length(1.day.ago, 1.day.from_now)
    end

    expect(@text).to eq('2 days')
  end

end
