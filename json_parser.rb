class JSONParser

  def initialize

  end

  def parse(json_string)
    case 
    when json_string == "true"
      true
    when json_string == "false"
      false
    when json_string == "null"
      nil
    when float?(json_string)
      Float(json_string)
    when integer?(json_string)
      Integer(json_string)
    when string?(json_string)
      json_string[1..-2].gsub(/\\(?=")/,"").gsub(/\\n/,"\n")
    when array?(json_string)
      #todo: split it better!
      json_string[1..-2].split(/,\s*/).map do |str|
        parse(str)
      end
    when hash?(json_string)
      #other thing
    else
      raise RuntimeError, json_string
    end
  end

  # { "key" => value (string, integer, boolean/null), .. }
  # [ " ", 11, true/false/null ]
#  def begin_string?
#  def consume_string

  def array?(str)
    array_regexp = /^\[.*\]$/
    str.match(array_regexp)
  end

  # "something": "something"
  def hash?(str)
    str.match(/^{.*}$/)
  end

  def string?(str)
    #start with a quote, end with a quote, and inside quotes are escaped
    # "nested \"quotes\""
    json_string_regexp = /^"([^"]|\\")*"$/
    str.match(json_string_regexp)
  end

  def float?(str)
    Float(str) && str =~ /^[0-9eE\+\.-]*$/
    rescue ArgumentError
      false
  end

  def integer?(str)
    Integer(str) && str =~ /^[0-9eE\+\.-]*$/
    rescue ArgumentError
      false
  end
end
