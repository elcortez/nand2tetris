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

  splitted.each do |word| # ORDER IS IMPORTANT
    if word.start_with?('"')
      string_started = true
      temp_string << word.split('"').join('')
    elsif word.end_with?('"')
      string_started = false
      temp_string << word.split('"').join('')
      tokenized_lines << "<stringConstant> #{temp_string.join(' ')} </stringConstant>"
      temp_string = []
    elsif string_started
      temp_string << word.split('"').join('')
    elsif is_integer(word)
      tokenized_lines << "<integerConstant> #{word} </integerConstant>"
    elsif XML_IDENTIFIERS.keys.include?(word)
      tokenized_lines << "<symbol> #{XML_IDENTIFIERS[word]} </symbol>"
    elsif SYMBOLS.include?(word)
      tokenized_lines << "<symbol> #{word} </symbol>"
    elsif KEYWORDS.include?(word)
      tokenized_lines << "<keyword> #{word} </keyword>"
    else
      tokenized_lines << "<identifier> #{word} </identifier>"
    end
  end

  return tokenized_lines
end

def apply_parameters_lists(tokenized_lines)
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

def apply_non_terminal_elements(tokenized_lines)
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
      keyword: '<keyword> field </keyword>',
      opener: '<keyword> field </keyword>',
      closer: '<symbol> ; </symbol>',
      opening_non_terminal_element: '<classVarDec>',
      closing_non_terminal_element: '</classVarDec>',
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
    {
      keyword: '<keyword> constructor </keyword>',
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
    {
      keyword: '<keyword> method </keyword>',
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
    {
      keyword: '<keyword> if </keyword>',
      opener: '<keyword> if </keyword>',
      closer: '<symbol> } </symbol>',
      opening_non_terminal_element: '<ifStatement>',
      closing_non_terminal_element: '</ifStatement>',
    },
    {
      keyword: '<keyword> while </keyword>',
      opener: '<keyword> while </keyword>',
      closer: '<symbol> } </symbol>',
      opening_non_terminal_element: '<whileStatement>',
      closing_non_terminal_element: '</whileStatement>',
    },
    {
      keyword: '<keyword> var </keyword>',
      opener: '<keyword> var </keyword>',
      closer: '<symbol> ; </symbol>',
      opening_non_terminal_element: '<varDec>',
      closing_non_terminal_element: '</varDec>',
    },
    {
      keyword: '<keyword> let </keyword>',
      opener: '<keyword> let </keyword>',
      closer: '<symbol> ; </symbol>',
      opening_non_terminal_element: '<letStatement>',
      closing_non_terminal_element: '</letStatement>',
    },
    {
      keyword: '<keyword> do </keyword>',
      opener: '<keyword> do </keyword>',
      closer: '<symbol> ; </symbol>',
      opening_non_terminal_element: '<doStatement>',
      closing_non_terminal_element: '</doStatement>',
    },
    {
      keyword: '<keyword> return </keyword>',
      opener: '<keyword> return </keyword>',
      closer: '<symbol> ; </symbol>',
      opening_non_terminal_element: '<returnStatement>',
      closing_non_terminal_element: '</returnStatement>',
    },
  ]

  non_terminal_elements.each do |non_terminal_element|
    elements_indexes = []
    old_indexes = []
    current_element_index = {}
    open_close_count = 0

    p "--------------------------------------------------- #{non_terminal_element[:keyword]} -------------------------------------"

    tokenized_lines.each_with_index do |line, index|
      if line.include?(non_terminal_element[:keyword])
        open_close_count = 0
        current_element_index[:open] = index
      end

      if line.include?(non_terminal_element[:opener]) && current_element_index[:open]
        open_close_count += 1
      elsif line.include?(non_terminal_element[:closer]) && current_element_index[:open]
        open_close_count -= 1
        if open_close_count == 0
          current_element_index[:close] = index
          elements_indexes << current_element_index
          current_element_index = {}
        end
      end
    end

    elements_indexes.each do |indexes|
      p "************* indexes #{indexes[:open]} #{indexes[:close]} #{tokenized_lines[indexes[:open]]} #{tokenized_lines[indexes[:close]]} *************"

      tokenized_lines = apply_non_terminal_element(tokenized_lines, indexes, non_terminal_element)

      # recalculating index positions since we are adding more lines for the non_terminal_elements
      elements_indexes.each_with_index do |i, index_of_i|
        elements_indexes[index_of_i][:open] += 1 if i[:open] > indexes[:open]
        elements_indexes[index_of_i][:open] += 1 if i[:open] > indexes[:close]
        elements_indexes[index_of_i][:close] += 1 if i[:close] > indexes[:open]
        elements_indexes[index_of_i][:close] += 1 if i[:close] > indexes[:close]
      end
    end
    # old_indexes.each_with_index do |begin_index, position_in_indexes_array|
    #   tokenized_lines = apply_non_terminal_element(tokenized_lines, begin_index, non_terminal_element)
    #
    #   old_indexes[(position_in_indexes_array + 1)..-1].each do |begin_index|
    #     old_indexes[old_indexes.index{|bi|bi==begin_index}] += 2
    #   end
    #
    #   if non_terminal_element[:additional_subroutine_body]
    #     additional_begin_index = tokenized_lines.index.with_index do |line, index|
    #       index > begin_index && line.include?(non_terminal_element[:additional_subroutine_body][:keyword])
    #     end
    #     tokenized_lines = apply_non_terminal_element(tokenized_lines, additional_begin_index, non_terminal_element[:additional_subroutine_body])
    #   end
    # end
  end

  return tokenized_lines
end

def apply_non_terminal_element(tokenized_lines, indexes, non_terminal_element)
  p "Applying at indexes #{indexes} lines #{tokenized_lines[indexes[:open]]} #{tokenized_lines[indexes[:close]]}"

  line_after = tokenized_lines[indexes[:close] + 1]
  offset = line_after ? line_after.split('<').first : ''

  tokenized_lines.insert(indexes[:close] + 1, "#{offset}#{non_terminal_element[:closing_non_terminal_element]}")
  tokenized_lines.insert(indexes[:open], "#{offset}#{non_terminal_element[:opening_non_terminal_element]}")

  tokenized_lines.each_with_index do |tl, index|
    # we inserted at :close + 1 BUT we also inserted at :open so it's +2, not +1
    next unless index > indexes[:open] && index < indexes[:close] + 2
    tokenized_lines[index] = "  #{tl}"
  end

  return tokenized_lines

  # end_index = nil
  # open_close_count = 0

  # tokenized_lines[begin_index..-1].each_with_index do |line, index|
  #   if line.include?(non_terminal_element[:opener])
  #     open_close_count += 1
  #   elsif line.include?(non_terminal_element[:closer])
  #     open_close_count -= 1
  #     if open_close_count == 0
  #       end_index = index + begin_index
  #       break
  #     end
  #   end
  # end

  # tokenized_lines[begin_index..end_index].each_with_index do |line, index|
  #   correct_index = index + begin_index
  #   raise "incorrect line offset application for line #{line}" if line != tokenized_lines[correct_index]
  #   tokenized_lines[correct_index] = "  #{line}"
  # end
  #
  # line_after = tokenized_lines[end_index + 1]
  # offset = line_after ? line_after.split('<').first : ''
  # offset = "#{offset}#{non_terminal_element[:additional_offset]}"

  # tokenized_lines.insert(end_index + 1, "#{offset}#{non_terminal_element[:closing_non_terminal_element]}")
  # tokenized_lines.insert(begin_index, "#{offset}#{non_terminal_element[:opening_non_terminal_element]}")

  # add closer at end_index
  # add opener at begin_index
  # add offset at all lines between begin_index + 1 and end_index - 1
end

def apply_statements(tokenized_lines)
  statements_index = 0
  statements = []

  brackets_index = 0
  brackets = []

  tokenized_lines.each_with_index do |tl, line_index|
    if tl.include?('<symbol> { </symbol>')
      brackets.insert(brackets_index, { open: line_index })
      brackets_index += 1
    elsif tl.include?('<symbol> } </symbol>')
      brackets[brackets_index - 1][:close] = line_index
      brackets_index -= 1
    end

    if tl.include?('Statement>') && !tl.include?('</') # any opening statement
      statements.insert(statements_index, { open: line_index })
      statements_index += 1
    elsif tl.include?('Statement>') && tl.include?('</')  # any closing statement
      statements[statements_index - 1][:close] = line_index
      statements_index -= 1
    end
  end

  brackets.sort_by!{|b|b[:open]}
  statements.sort_by!{|b|b[:open]}

  brackets.each do |bracket_pair|
    this_opening = bracket_pair[:open]
    closest_next_opening_bracket_index = brackets.map { |b| b[:open] if b[:open] > this_opening }.compact.first
    closest_next_opening_statement_index = statements.map { |b| b[:open] if b[:open] > this_opening }.compact.first
    next if closest_next_opening_bracket_index && (closest_next_opening_bracket_index < closest_next_opening_statement_index)

    if closest_next_opening_statement_index
      current_offset = tokenized_lines[closest_next_opening_statement_index].split('<').first
      tokenized_lines.insert(closest_next_opening_statement_index, "#{current_offset}<statements>")

      brackets.each do |b|
        b[:open] += 1 if b[:open] > closest_next_opening_statement_index
        b[:close] += 1 if b[:close] > closest_next_opening_statement_index
      end

      statements.each do |s|
        s[:open] += 1 if s[:open] > closest_next_opening_statement_index
        s[:close] += 1 if s[:close] > closest_next_opening_statement_index
      end

      # not sure : only works if the } is right BELOW the closing statement
      tokenized_lines.insert(bracket_pair[:close], "#{current_offset}</statements>")

      brackets.each do |b|
        b[:open] += 1 if b[:open] > bracket_pair[:close]
        b[:close] += 1 if b[:close] > bracket_pair[:close]
      end

      statements.each do |s|
        s[:open] += 1 if s[:open] > bracket_pair[:close]
        s[:close] += 1 if s[:close] > bracket_pair[:close]
      end

      tokenized_lines.each_with_index do |tl, index|
        next unless index > closest_next_opening_statement_index && index < bracket_pair[:close]
        tokenized_lines[index] = "  #{tl}"
      end
    end
  end

  return tokenized_lines
end

def translate_jack_file_content(jack_file, xml_file, testing_tokenizer_only)
  tokenized_lines = []

  sanitized_lines(jack_file).each do |line|
    tokenized_lines << generate_tokenized_lines(line)
  end

  if !testing_tokenizer_only
    tokenized_lines = apply_parameters_lists(tokenized_lines)
    tokenized_lines = apply_non_terminal_elements(tokenized_lines)
    # tokenized_lines = apply_statements(tokenized_lines)
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
    # p "Discrepancy found on line #{index + 1} : #{line} vs #{test_file_lines[index]}"
  end
end
