workers ENV.fetch('PUMA_WORKERS', 3).to_i
threads ENV.fetch('MIN_THREADS', 1).to_i, ENV.fetch('MAX_THREADS', 10).to_i

preload_app!

rackup      DefaultRackup
environment ENV.fetch('RAILS_ENV', 'development')
bind        ENV.fetch('PUMA_BIND_PATH', 'tcp://0.0.0.0:3000')

activate_control_app 'tcp://0.0.0.0:9292', { no_token: true }

on_worker_boot do
  # worker specific setup
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env]
    config['pool'] = ENV.fetch('DB_POOL_SIZE', 16)
    ActiveRecord::Base.establish_connection(config)
  end
end


