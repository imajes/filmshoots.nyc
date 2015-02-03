RSpec::Matchers.define :use_serializer do

  match do
    serializer_header == expected.to_s
  end

  failure_message do
    "Expected that #{serializer_header} would be #{expected}"
  end

  failure_message_when_negated do
    "Expected that #{serializer_header} would not be #{expected}"
  end

end

def serializer_header
  response.headers['X-Serializer']
end
