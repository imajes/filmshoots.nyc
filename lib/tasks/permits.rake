namespace :permits do

  desc 'Parses permit locations'
  task :parse => :environment do
     Permit.all.each do |o|
       next if o.addresses.any?
       puts "#{o.id}: #{o.project.title}"
       o.expand_addresses
       sleep(3)
     end
  end
end
