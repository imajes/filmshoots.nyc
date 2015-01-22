class PermitSerializer < ActiveModel::Serializer
  attributes :id, :event_name, :event_type, :boro, :event_start, :event_end


  def locations_map

  end
end
