module PrettyHelper
  def language_map
    {"fr"=>"French", "en"=>"English", "ar"=>"Arabic", "ja"=>"Japanese", "es"=>"Spanish", "de"=>"German", "it"=>"Italian", "id"=>"Indonesian", "pt"=>"Portuguese", "ko"=>"Korean", "tr"=>"Turkish", "ru"=>"Russian", "nl"=>"Dutch", "fil"=>"Filipino", "msa"=>"Malay", "zh-tw"=>"Traditional Chinese", "zh-cn"=>"Simplified Chinese", "hi"=>"Hindi", "no"=>"Norwegian", "sv"=>"Swedish", "fi"=>"Finnish", "da"=>"Danish", "pl"=>"Polish", "hu"=>"Hungarian", "fa"=>"Farsi", "he"=>"Hebrew", "ur"=>"Urdu", "th"=>"Thai"}
  end
  
  def language_name(lang)
    language_map[lang]
  end
end