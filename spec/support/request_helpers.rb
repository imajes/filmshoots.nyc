# spec/support/request_helpers.rb
module RequestHelpers
  def parsed_body
    JSON.parse(response.body)
  end

  def get_json(path, opts={})
    get(path, format: :json, **opts)
  end
end
