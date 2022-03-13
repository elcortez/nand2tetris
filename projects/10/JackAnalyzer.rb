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

def translated_lines(line, file_offset)
  lines = []
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
      lines << "#{'  '* file_offset}<stringConstant> #{temp_string.join(' ')} </stringConstant>"
      temp_string = []
    elsif string_started # ORDER IS IMPORTANT
      temp_string << word.split('"').join('')
    elsif is_integer(word)
      lines << "#{'  '* file_offset}<integerConstant> #{word} </integerConstant>"
    elsif XML_IDENTIFIERS.keys.include?(word)
      lines << "#{'  '* file_offset}<symbol> #{XML_IDENTIFIERS[word]} </symbol>"
    elsif SYMBOLS.include?(word)
      lines << "#{'  '* file_offset}<symbol> #{word} </symbol>"
    elsif KEYWORDS.include?(word)
      lines << "#{'  '* file_offset}<keyword> #{word} </keyword>"
    else # ORDER IS IMPORTANT
      lines << "#{'  '* file_offset}<identifier> #{word} </identifier>"
    end
  end

  lines = apply_line_offset(lines, file_offset)

  return lines
end

def apply_line_offset(lines, file_offset)
  p '...............'
  p lines

  if lines.any? { |line| line.include?('function') }
    open_index = lines.index { |line| line.include?('<symbol> ( </symbol>') }
    lines.insert(open_index + 1, "#{'  '* file_offset}<parameterList>")

    close_index = lines.index { |line| line.include?('<symbol> ) </symbol>') }
    lines.insert(close_index, "#{'  '* file_offset}</parameterList>")

    open_index = lines.index { |line| line.include?('<parameterList>') }
    close_index = lines.index { |line| line.include?('</parameterList>') }

    lines.each_with_index do |line, index|
      next if index < open_index + 1 || index > close_index - 1
      lines[index] = "  #{lines[index]}"
    end
  end

  return lines
end

def translate_jack_file_content(jack_file, xml_file)
  file_offset = 0

  sanitized_lines(jack_file).each do |line|

    if line.start_with?('class')
      xml_file.puts('<class>')
      file_offset += 1
    elsif line.start_with?('function')
      xml_file.puts("#{'  ' * file_offset}<subroutineDec>")
      file_offset += 1
    end

    lines = translated_lines(line, file_offset)

    lines.each do |xml_command|
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
    File.open(jack_file) { |jack_file| translate_jack_file_content(jack_file, xml_file) }
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
