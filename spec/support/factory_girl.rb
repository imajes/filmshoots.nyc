RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

module Permits::FactoryGirl
  def self.track_factories
    @factory_girl_results = {}

    ActiveSupport::Notifications.subscribe('factory_girl.run_factory') do |name, start, finish, id, payload|
      # puts "#{Epixcms::Movies::Movie.count} - #{payload[:name]}" if payload[:strategy] == :create
      factory_name = payload[:name]
      strategy_name = payload[:strategy]
      @factory_girl_results[factory_name] ||= {}
      @factory_girl_results[factory_name][strategy_name] ||= 0
      @factory_girl_results[factory_name][strategy_name] += 1
    end
  end

  def self.print_statistics
    return nil unless (@factory_girl_results.present? && @factory_girl_results.any?)

    puts "\nFactory Girl Run Results.. [strategies per factory]:"
    rows = @factory_girl_results.map { |r| [r.first, r.last.fetch(:create, 0), r.last.fetch(:build, 0), r.last.fetch(:build_stubbed, 0)] }
    rows = rows.sort_by {|t| [t[1], t[3]] }.reverse

    table = Terminal::Table.new headings: ['Factory', 'Created', 'Built', 'Stubbed'], rows: rows
    table.align_column(0, :right)
    table.align_column(1, :center)
    table.align_column(2, :center)
    table.align_column(3, :center)

    puts table
  end
end
