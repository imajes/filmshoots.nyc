require 'csv'
STDOUT.sync = true

namespace :import do
  desc 'import projects list...'
  task projects: :environment do
    size = 1

    CSV.foreach(Rails.root.join('db/projects.csv')) do |project|
      next if project.first == 'Project Id'

      project.map { |t| t.to_s.strip! }
      id, title, company, category = project

      Project.import(id.to_i, title, company, category)

      print '.'
      size += 1
    end

    puts "\nDone importing #{size} project records..."
  end

  desc 'import permits...'
  task permits: :environment do
    size = 1

    if Project.count.zero?
      raise RuntimeError.new 'No projects exist; import them first...'
    end

    CSV.foreach(Rails.root.join('db/permits.csv'), headers: true) do |permit|
      ImportPermitService.run!(permit)

      print '.'
      size += 1
    end

    puts "\nDone importing #{size} permit records..."
  end

  desc 'geocode addresses...'
  task geocode: :environment do
    Permit.find_in_batches(batch_size: 100).each do |batch|
      batch.each do |o|
        next if o.locations.any?
        puts "Parsing #{o.id} - #{o.project.title}: #{o.event_name}..."
        ParseAddressService.new(o).process!
      end
    end
  end
end
