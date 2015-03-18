# spec/support/request_helpers.rb
module RequestHelpers
  def parsed_body
    JSON.parse(response.body)
  end

  def json_get(path)
    get path, format: :json
  end
end
