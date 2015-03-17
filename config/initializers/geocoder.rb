Geocoder.configure(
  lookup: :google,
  api_key: 'AIzaSyBsVKsp640WcCA0uL9kw1jN6HOb_NIuOEs',
  # lookup: :bing,
  # api_key: 'AuxKs4V8KDMdett2IVmGdvTmoHtNdnkIBx_alUz3FcIUqQnpxkUsKtB0qp9tIMNS',

  https_proxy: 'http://quotaguard2415:d990210e1b3d@proxy.quotaguard.com:9292',
  cache: Redis.new,
  timeout: 5,
  use_https: true
)
