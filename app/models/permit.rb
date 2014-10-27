class Permit < ActiveRecord::Base

  belongs_to :project
  has_and_belongs_to_many :locations

  # sql/stat/grouping queries

  def self.issued_by_month
    sql = "select count(*) as count, date_trunc('month', event_start) as month, date_trunc('year', event_start) as year from permits group by year, month order by year asc, month asc"
    self.find_by_sql(sql)
  end

  def self.import(item)
    # [:event_id, :project_title, :event_name, :event_type, :event_start_date, :event_end_date, :entered_on, :location, :zip, :boro, :project_id]

    item = item.to_h.symbolize_keys!
    item.values.map { |x| x.strip! unless x.nil? }

    permit = Permit.where(event_ref: item[:event_id].to_i).first_or_initialize

    permit.project = Project.where(city_ref: item[:project_id].to_i).first

    attrs = { event_name:        item[:event_name],
              event_type:        item[:event_type],
              boro:              item[:boro],
              original_location: item[:location],
              zip:               item[:zip].gsub(/,$/, ''),
              event_start:       Time.strptime(item[:event_start_date], "%m/%d/%y %H:%M %p"),
              event_end:         Time.strptime(item[:event_end_date], "%m/%d/%y %H:%M %p"),
              entered_on:        Time.strptime(item[:entered_on], "%m/%d/%y %H:%M %p")
    }

    permit.assign_attributes(attrs)
    permit.save!

  end

  def original_location_as_paragraph
    original_location.gsub(/\s+/, " ").split(",").map do |line|

      line.strip!

      if line =~ /\:/
        line = "\n#{line}"
      elsif line =~ /between/
        line = "\t#{line}".gsub("&", "_and_")
      else
        line = line
      end

    end.join("\n").gsub(" and ", " & ").gsub(" between ", " <> ")
  end

end
