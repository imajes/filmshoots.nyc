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

  desc 'remove address orphans...'
  task address_orphans: :environment do

    uniq_addr_ids = Address.pluck(:id)
    uniq_map_type_addr_ids = MapType.select("distinct address_id").pluck(:address_id)

    orphans = uniq_addr_ids - uniq_map_type_addr_ids

    puts "\nThere are #{orphans.size} orphaned address records."
  end

  desc 'parse addresses...'
  task address_parse: :environment do
    Permit.find_in_batches(batch_size: 100).each do |batch|
      batch.each do |o|
        next if o.locations.any?
        puts "Parsing #{o.id} - #{o.project.title}: #{o.event_name}..."
        ParseAddressService.new(o).process!
      end
    end
  end

  namespace :geocode do
    desc 'geocode addresses...'
    task locations: :environment do
      idx = 0
      Address.not_geocoded.find_in_batches(batch_size: 3000).each do |batch|
        batch.each do |addr|
          offset = (idx * 24).hours + rand(0..60).minutes
          GeocodeAddressJob.perform_in(offset, addr.id)
        end
        idx += 1
      end
    end
  end
end


namespace :data do
  desc 'reset counters'
  task reset_counters: :environment do
    Permit.counter_culture_fix_counts
    Project.counter_culture_fix_counts
  end

  desc 'reindex dab'
  task reindex: :environment do
    Project.reindex
    Company.reindex
  end
end
