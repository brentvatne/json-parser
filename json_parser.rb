require 'strscan'
class JSONParser
  AST = Struct.new(:value)

  def parse(json_string)
    @str_scanner = StringScanner.new(json_string)
    val = do_parsing
    unless @str_scanner.eos?
      raise(RuntimeError, "%s :: %s" % [json_string, @str_scanner.post_match])
    end
    val
  end

  def do_parsing
    val = parse_object    ||
            parse_array   ||
            parse_string  ||
            parse_float   ||
            parse_int     ||
            parse_literal
    val.value if val
  end

  def parse_object
#     return nil unless @str_scanner.scan(/^{/)
  end

  def parse_array
    return nil unless @str_scanner.scan(/^\[/)
    new_array = []
    while !@str_scanner.scan(/^\]/)
      next_object = do_parsing

      raise RuntimeError unless next_object
      new_array << next_object
      @str_scanner.scan(/^,\s*/)
    end
    AST.new( new_array )
  end

  def parse_string
    if str = @str_scanner.scan(/^"([^"]|\\")*[^\\]"/) || @str_scanner.scan(/^""/)
      AST.new( str[1..-2].gsub(/\\"/,'"').gsub(/\\n/,"\n") )
    end
  end

  def parse_int
    if int = @str_scanner.scan(/-?[0-9]+/)
      AST.new( Integer(int) )
    end
  end

  def parse_float
    if float = @str_scanner.scan(/-?[0-9]+\.[0-9]*(e[-+]?)?[0-9]+/)
      AST.new( Float(float) )
    end
  end

  def parse_literal
    return AST.new( true )  if @str_scanner.scan(/true/)
    return AST.new( false ) if @str_scanner.scan(/false/)
    return AST.new( nil )   if @str_scanner.scan(/null/)
  end
end
