require 'csv'

namespace :import do

  desc "import projects list..."
  task :projects => :environment do

    size = 1

    CSV.foreach(Rails.root.join("db/projects.csv")) do |project|
      next if project.first == "Project Id"

      project.map {|t| t.to_s.strip! }
      id, title, company, category = project

      Project.import(id.to_i, title, company, category)

      size += 1
    end

    puts "Done importing #{size} project records..."
  end

end
