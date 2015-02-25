module ApplicationHelper
  def shoot_length(event_start, event_end)
    distance_of_time_in_words(event_start, event_end)
  end
end
