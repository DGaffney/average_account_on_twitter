module LayoutHelper  
  helpers do
    def partial(template, *args)
      options = args.extract_options!
      options.merge!(:layout => false)
      if collection = options.delete(:collection) then
        collection.inject([]) do |buffer, member|
          buffer << erb(path_to_partial_path(template), options.merge(
                                    :layout => false, 
                                    :locals => {path_to_partial_path(template) => member}
                                  )
                       )
        end.join("\n")
      else
        erb path_to_partial_path(template), options
      end
    end
    
    def path_to_partial_path(path)
      #converts string of /partial/path to /partial/_path symbol
      broken_path = path.split("/")
      partial_file = "_"+broken_path.last
      return (broken_path[0..-2]|[partial_file]).join("/").to_sym
    end
  end

  def format_date(date, format)
    return '' if date.nil?
    tz = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
    date = DateTime.parse(date).to_time if date.is_a? String
    date.in_time_zone(tz).strftime(format)
  end

  def class_compare(value, alter_value)
    value > alter_value ? "icon-thumbs-up" : "icon-thumbs-down"
  end
end
