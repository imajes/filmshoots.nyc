Geocoder.configure(
  lookup: :google,
  api_key: 'AIzaSyBsVKsp640WcCA0uL9kw1jN6HOb_NIuOEs',
  # lookup: :bing,
  # api_key: 'AuxKs4V8KDMdett2IVmGdvTmoHtNdnkIBx_alUz3FcIUqQnpxkUsKtB0qp9tIMNS',
  cache: Redis.new,
  timeout: 5,
  use_https: true
)
