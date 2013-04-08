module PrettyHelper
  def language_map
    {"fr"=>"French", "en"=>"English", "ar"=>"Arabic", "ja"=>"Japanese", "es"=>"Spanish", "de"=>"German", "it"=>"Italian", "id"=>"Indonesian", "pt"=>"Portuguese", "ko"=>"Korean", "tr"=>"Turkish", "ru"=>"Russian", "nl"=>"Dutch", "fil"=>"Filipino", "msa"=>"Malay", "zh-tw"=>"Traditional Chinese", "zh-cn"=>"Simplified Chinese", "hi"=>"Hindi", "no"=>"Norwegian", "sv"=>"Swedish", "fi"=>"Finnish", "da"=>"Danish", "pl"=>"Polish", "hu"=>"Hungarian", "fa"=>"Farsi", "he"=>"Hebrew", "ur"=>"Urdu", "th"=>"Thai", "cs" => "Czech", "ca" => "Catalan", "el" => "Greek"}
  end
  
  def language_name(lang)
    language_map[lang]
  end
  
  def name_for_length_longitudinal(length)
    return {
      "day" => "Day",
      "week" => "for the past week of data",
      "month" => "for the past month of data",
      "6month" => "for the past six months of data",
      "year" => "for the past year of data",
      "all_time" => "for all time recorded",
    }[length]
  end
end