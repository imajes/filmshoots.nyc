
# ignore the build directory
ignore /\.permits/
ignore /\.git/

# RSPEC
guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})          { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/.+_helper.rb$})       { 'spec' }
  watch(%r{^spec/shared/(.+)\.rb$}) { 'spec' }
  watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch('config/routes.rb')                           { 'spec/routing' }
  watch('app/controllers/application_controller.rb')  { 'spec/controllers' }

  # specific lib specs
  watch('spec/locations.yml')                         { 'spec/lib' }

  watch(%r{^spec/factories/(.+)\.rb$})                { |m| ['spec/lint_spec.rb', 'spec/models', "spec/controllers/#{m[1]}_controller_spec.rb"] }
end

guard :bundler do
  watch('Gemfile')
end

notification(:terminal_notifier)

# for blink1 notifications
notification(:file, path: '.guard_result')

require 'guard_blink1'
guard :shell do
  watch '.guard_result' do
    firstline =  File.read('.guard_result').lines.first.strip
    GuardBlink1.blink_colour(firstline)
  end
end

