class String
  ATEXT = /[A-Za-z0-9!#\$%&'\*\+\-\/=\?\^_`\{\|\}\~]/
  DOT_ATOM = /(?:#{ATEXT})+(?:\.(?:#{ATEXT})+)*/

  TEXT = /[\x01-\x09\x0B\x0C\x0E-\x7F]/
  QTEXT = /[\x01-\x08\x0B\x0C\x0E-\x1F\x21\x23-\x5B\x5D-\x7E]/
  QUOTED_PAIR = /\\#{TEXT}/
  QCONTENT = /(?:#{QTEXT}|#{QUOTED_PAIR})/
  QUOTED_STRING = /"(?:\s*#{QCONTENT})*\s*"/

  DTEXT = /[\x01-\x08\x0B\x0C\x0E-\x1F\x21-\x5A\x5E-\x7E]/
  DCONTENT = /(?:#{DTEXT}|#{QUOTED_PAIR})/
  DOMAIN_LITERAL = /\[(?:\s*#{DCONTENT})*\s*\]/
  DOMAIN = /(?:#{DOT_ATOM}|#{DOMAIN_LITERAL})/

  LOCAL_PART = /(?:#{DOT_ATOM}|#{QUOTED_STRING})/

  ADDR_SPEC = /^(#{LOCAL_PART})@(#{DOMAIN})$/
  def url?
    return !(self =~ URI::regexp).nil?
  end
  
  def valid_email_address?
    result = (self =~ ADDR_SPEC)
    return !result.nil?
  end
  
  def blank?
    # 1.8 does not takes [:space:] properly
    if encoding_aware?
      begin
        self !~ /[^[:space:]]/
      rescue
        p self
        false
      end
    else
      self !~ NON_WHITESPACE_REGEXP
    end
  end

  def to_url
    url = URI.parse(URI.encode(self.strip)).to_s
    url
  end
  
  def underscore_to_pretty
    self.split("_").collect(&:capitalize).join(" ")
  end

  def truncate(opts={})
    opts = Hashie::Mash[opts]
    opts[:length] ||= 30
    opts.ending_character ||= ""
    set = ""
    text = self.split(" ")
    text.each do |word|
      set = "#{set}#{word} " if opts[:length] >= (set.length + word.length)
    end
    set+opts.ending_character
  end
  
  def linkify
    self.gsub!(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/, '<a href="\1" target="_blank">\1</a>')
    self.gsub!(/(#\w*)/, '<a href="https://twitter.com/search?q=\1" target="_blank">\1</a>')
    self.gsub!(/@(\w*)/, '<a href="https://twitter.com/\1" target="_blank">@\1</a>')
    self
  end

end