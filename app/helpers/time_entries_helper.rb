module TimeEntriesHelper
  
  Weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']  
  
  def date_label_for(object)
    "#{object.date} (#{Weekdays[object.date.wday - 1]})"
  end
  
  def ids_from(models)
    models.collect { |model| model.id }
  end
  
  def select_by_activity(time_entries, activity)
    time_entries.select { |te| te.activity == activity }.sort
  end
    
end