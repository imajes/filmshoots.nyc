require 'csv'
STDOUT.sync = true

namespace :import do

  desc "import projects list..."
  task :projects => :environment do

    size = 1

    CSV.foreach(Rails.root.join("db/projects.csv")) do |project|
      next if project.first == "Project Id"

      project.map {|t| t.to_s.strip! }
      id, title, company, category = project

      Project.import(id.to_i, title, company, category)

      print "."
      size += 1
    end

    puts "\nDone importing #{size} project records..."
  end

  desc "import permits..."
  task :permits => :environment do

    size = 1

    if Project.count.zero?
      raise RuntimeError.new "No projects exist; import them first..."
    end

    CSV.foreach(Rails.root.join("db/permits.csv"), headers: true) do |permit|

      Permit.import(permit)

      print "."
      size += 1
    end

    puts "\nDone importing #{size} permit records..."
  end


  desc "bleh"
  task :test => :environment do

    require Rails.root.join('lib/location_parser')


    Permit.where("random() < 0.01").limit(10).each do |permit|
      puts "----- #{permit.id} ------"
      puts permit.original_location_as_paragraph
      puts ""
      run_parse(permit.original_location_as_paragraph)

    end

  end

  desc "bleh"
  task :para => :environment do

    Permit.where("random() < 0.01").limit(10).each do |permit|
      puts "----- #{permit.id} ------"
      puts permit.original_location_as_paragraph
      puts ""
    end

  end

  desc "bleh"
  task :explore => :environment do

    require Rails.root.join('lib/location_parser')


    Permit.where("random() < 0.01").limit(10).each do |permit|

      loc = permit.original_location.gsub(/\s+/, ' ')
      ap loc
      ap loc.split(",").map(&:strip)

    end

  end

  def run_parse(str)
    begin
      x = LocationParser.new.parse(str)
      ap x
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree

      # print "\n"
      # 1.upto(str.size).each { |x| print "#{x} " }
      #
      # print "\n"
      #
      # str.split("").each_with_index {|c, idx| spacer = " " * idx.to_s.size; print "#{c}#{spacer}" }
      print "\n\n"
    end

  end
end
