if Rails.env.development?
  Oj.default_options = {indent: 2}
end
