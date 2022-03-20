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
  tokenized_lines = tokenized_lines.flatten

  non_terminal_elements = [
    {
      keyword: '<keyword> class </keyword>',
      opener: '<symbol> { </symbol>',
      closer: '<symbol> } </symbol>',
      opening_non_terminal_element: '<class>',
      closing_non_terminal_element: '</class>'
    },
    {
      keyword: '<keyword> function </keyword>',
      opener: '<symbol> { </symbol>',
      closer: '<symbol> } </symbol>',
      opening_non_terminal_element: '<subroutineDec>',
      closing_non_terminal_element: '</subroutineDec>',
      additional_subroutine_body: {
        keyword: '<symbol> { </symbol>',
        opener: '<symbol> { </symbol>',
        closer: '<symbol> } </symbol>',
        opening_non_terminal_element: '<subroutineBody>',
        closing_non_terminal_element: '</subroutineBody>',
        additional_offset: '  '
      }
    },
  ]

  non_terminal_elements.each do |non_terminal_element|
    begin_indexes = []
    tokenized_lines.each_with_index { |line, index| begin_indexes << index if line.include?(non_terminal_element[:keyword]) }

    begin_indexes.each do |begin_index|
      tokenized_lines = apply_non_terminal_element(tokenized_lines, begin_index, non_terminal_element)

      if non_terminal_element[:additional_subroutine_body]
        additional_begin_index = tokenized_lines.index.with_index do |line, index|
          index > begin_index && line.include?(non_terminal_element[:additional_subroutine_body][:keyword])
        end
        tokenized_lines = apply_non_terminal_element(tokenized_lines, additional_begin_index, non_terminal_element[:additional_subroutine_body])
      end
    end
  end
  # subroutine body
  # var decl
  # statements
  # letstatement
  # expression
  # term

  return tokenized_lines
end

def apply_non_terminal_element(tokenized_lines, begin_index, non_terminal_element)
  end_index = nil
  open_close_count = 0

  tokenized_lines[begin_index..-1].each_with_index do |line, index|
    if line.include?(non_terminal_element[:opener])
      open_close_count += 1
    elsif line.include?(non_terminal_element[:closer])
      open_close_count -= 1
      if open_close_count == 0
        end_index = index + begin_index
        break
      end
    end
  end

  tokenized_lines[begin_index..end_index].each_with_index do |line, index|
    correct_index = index + begin_index
    raise "incorrect line offset application for line #{line}" if line != tokenized_lines[correct_index]
    tokenized_lines[correct_index] = "  #{line}"
  end

  line_after = tokenized_lines[end_index + 1]
  offset = line_after ? line_after.split('<').first : ''
  offset = "#{offset}#{non_terminal_element[:additional_offset]}"

  tokenized_lines.insert(end_index + 1, "#{offset}#{non_terminal_element[:closing_non_terminal_element]}")
  tokenized_lines.insert(begin_index, "#{offset}#{non_terminal_element[:opening_non_terminal_element]}")

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

  tokenized_lines.flatten.each do |xml_command|
    xml_file.puts(xml_command)
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
    p "Discrepancy found on line #{index + 1} : #{line} vs #{test_file_lines[index]}"
  end
end
