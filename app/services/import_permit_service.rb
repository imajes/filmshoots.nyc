class ImportPermitService
  attr_reader :attrs, :item

  def self.run!(item)
    new(item).process!
  end

  def initialize(new_permit)
    # [:event_id, :project_title, :event_name, :event_type, :event_start_date, :event_end_date, :entered_on,
    # :location, :zip, :boro, :project_id]

    @item = new_permit.to_h.symbolize_keys!
    item.values.map { |x| x.strip! unless x.nil? }

    @attrs = { event_name:        item[:event_name],
               event_type:        item[:event_type],
               boro:              item[:boro],
               original_location: item[:location],
               zip:               item[:zip].gsub(/,$/, ''),
               event_start:       convert_to_time(item[:event_start_date]),
               event_end:         convert_to_time(item[:event_end_date]),
               entered_on:        convert_to_time(item[:entered_on])
    }
  end

  def process!
    permit = Permit.where(event_ref: item[:event_id].to_i).first_or_initialize
    permit.project = Project.where(city_ref: item[:project_id].to_i).first
    permit.assign_attributes(attrs)
    permit.save!

    # decipher addresses...
    ParseAddressService.run!(permit)
  end


  def convert_to_time(ts)
    Chronic.time_class = Time.zone
    Chronic.parse(ts)
  end
end
