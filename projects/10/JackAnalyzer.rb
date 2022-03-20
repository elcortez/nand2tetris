SYMBOLS = [
  '{', '}', '[', ']', '(', ')' , '.', ',', ';', '+',
  '-', '*', '/', '&', '|', '>', '<', '=', '~'
]

XML_IDENTIFIERS = {
  '<' => '&lt;',
  '>' => '&gt;',
  '\"' => '&quot;',
  '&' => '&amp;'
}

KEYWORDS = [
  'class', 'constructor', 'function', 'method', 'field', 'static', 'var', 'int',
  'char', 'boolean', 'void', 'true', 'false', 'null', 'this', 'let', 'do', 'if',
  'else', 'while', 'return'
]

def is_integer(word)
  Integer(word) rescue false
end

def sanitized_lines(jack_file)
  multiline_comment_started = false

  return jack_file.each_line.map(&:strip).reject do |l|
    multiline_comment_started = true if l.start_with?('/*')
    multiline_comment_started = false if l.end_with?('*/')

    (l.start_with?('*') && multiline_comment_started == true) || l.start_with?('/*') || l.end_with?('*/') || l.start_with?('//') || l.empty?

  end.map { |l| l.split('//').first.strip }
end

def generate_tokenized_lines(line)
  tokenized_lines = [] # tokenized_lines = tokenized_lines
  string_started = false
  temp_string = []
  splitted = line.split(/\s(?!\")/)
    .map { |string|string.split(/(\.)|(\{)|(\})|(\[)|(\])|(\()|(\))|(\,)|(\;)|(\+)|(\-)|(\*)|(\/)|(\&)|(\|)|(\>)|(\<)|(\=)|(\~)/) }
    .flatten
    .reject { |s| s == '' }
    .map(&:strip)

  splitted.each do |word|
    if word.start_with?('"') # ORDER IS IMPORTANT
      string_started = true
      temp_string << word.split('"').join('')
    elsif word.end_with?('"') # ORDER IS IMPORTANT
      string_started = false
      temp_string << word.split('"').join('')
      tokenized_lines << "<stringConstant> #{temp_string.join(' ')} </stringConstant>"
      temp_string = []
    elsif string_started # ORDER IS IMPORTANT
      temp_string << word.split('"').join('')
    elsif is_integer(word)
      tokenized_lines << "<integerConstant> #{word} </integerConstant>"
    elsif XML_IDENTIFIERS.keys.include?(word)
      tokenized_lines << "<symbol> #{XML_IDENTIFIERS[word]} </symbol>"
    elsif SYMBOLS.include?(word)
      tokenized_lines << "<symbol> #{word} </symbol>"
    elsif KEYWORDS.include?(word)
      tokenized_lines << "<keyword> #{word} </keyword>"
    else # ORDER IS IMPORTANT
      tokenized_lines << "<identifier> #{word} </identifier>"
    end
  end

  return tokenized_lines
end

def apply_single_line_offsets(tokenized_lines)
  tokenized_lines.each do |single_tokenized_line|
    if single_tokenized_line.any? { |tline| tline.include?('function') }
      open_parameter_index = single_tokenized_line.index { |tline| tline.include?('<symbol> ( </symbol>') }
      single_tokenized_line.insert(open_parameter_index + 1, "<parameterList>")

      close_parameter_index = single_tokenized_line.index { |tline| tline.include?('<symbol> ) </symbol>') }
      single_tokenized_line.insert(close_parameter_index, "</parameterList>")

      open_parameter_index = single_tokenized_line.index { |tline| tline.include?('<parameterList>') }
      close_parameter_index = single_tokenized_line.index { |tline| tline.include?('</parameterList>') }

      single_tokenized_line.each_with_index do |line, index|
        next if index < open_parameter_index + 1 || index > close_parameter_index - 1
        single_tokenized_line[index] = "  #{single_tokenized_line[index]}"
      end
    end
  end

  return tokenized_lines
end

def apply_multi_lines_offsets(tokenized_lines)
  # file_offset = 0
  # if line.start_with?('class')
  #   xml_file.puts('<class>')
  #   file_offset += 1
  # elsif line.start_with?('function')
  #   xml_file.puts("#{'  ' * file_offset}<subroutineDec>")
  #   file_offset += 1
  # end

  # class
  # subroutine decl
  # subroutine body
  # var decl
  # statements
  # letstatement
  # expression
  # term

  return tokenized_lines
end

def translate_jack_file_content(jack_file, xml_file, testing_tokenizer_only)
  tokenized_lines = []

  sanitized_lines(jack_file).each do |line|
    tokenized_lines << generate_tokenized_lines(line)
  end

  if !testing_tokenizer_only
    tokenized_lines = apply_single_line_offsets(tokenized_lines)
    tokenized_lines = apply_multi_lines_offsets(tokenized_lines)
  end

  tokenized_lines.each do |xml_commands|
    xml_commands.each do |xml_command|
      xml_file.puts(xml_command)
    end
  end
end

folder_path = ARGV[0].split('/')
directory = folder_path.last.end_with?('.jack') ? folder_path[0..-2] : folder_path
jack_files = Dir[directory.join('/') + '/*'].select { |filename| filename.split('.').last == 'jack' }
testing = ENV['USER'] == 'pierrehersant' # Testing only happens on my computer
testing_tokenizer_only = false

jack_files.each do |jack_file|
  p '..........................................................................'
  p "Compiling #{jack_file}"
  extension = testing ? '2.xml' : '.xml' # Keeping test files intact while testing
  xml_file_name = jack_file.gsub(/.jack/, extension)

  File.open(xml_file_name, 'w') do |xml_file|
    xml_file.puts('<tokens>') if testing_tokenizer_only
    File.open(jack_file) { |jack_file| translate_jack_file_content(jack_file, xml_file, testing_tokenizer_only) }
    xml_file.puts('</tokens>') if testing_tokenizer_only
  end

  return unless testing

  extension = testing_tokenizer_only ? 'T.xml' : '.xml'
  test_file_name = jack_file.gsub(/.jack/, extension)
  p "Testing file #{test_file_name} vs #{xml_file_name}"
  test_file_lines = File.open(test_file_name).each_line.to_a.map(&:strip)
  xml_file_lines = File.open(xml_file_name).each_line.to_a.map(&:strip)

  xml_file_lines.each_with_index do |line, index|
    next if line == test_file_lines[index]
    p "Discrepancy found on line #{index} : #{line} vs #{test_file_lines[index]}"
  end
end
