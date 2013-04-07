module PrettyHelper
  def language_map
    {"en" => "English", "ja" => "Japanese", "it" => "Italian", "de" => "German", "fr" => "French", "kr" => "Korean", "es" => "Spanish", "id" => "Indonesian", "fil" => "Filipino", "nl" => "Dutch", "pt" => "Portuguese", "pl" => "Polish", "sv" => "Swedish", "ru" => "Russian", "ar" => "Arabic", "no" => "Norwegian", "tr" => "Turkish", "hu" => "Hungarian", "zh-cn" => "Mandarin", "ko" => "Korean"}
  end
  
  def language_name(lang)
    language_map[lang]
  end
end