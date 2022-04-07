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

TERMS_SEPARATORS = [
  '<symbol> , </symbol>',
  '<symbol> &gt; </symbol>',
  '<symbol> &lt; </symbol>',
  '<symbol> | </symbol>',
  '<symbol> * </symbol>',
  '<symbol> / </symbol>'
]

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
    if single_tokenized_line.any? { |tline| ['function', 'method', 'constructor'].any? { |m| tline.include?(m) } }
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
      keyword: '<keyword> static </keyword>',
      opener: '<keyword> static </keyword>',
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
    {
      keyword: '<keyword> if </keyword>',
      opener: '<keyword> if </keyword>',
      closer: '<symbol> } </symbol>',
      next_line_cancelling_one_closer: '<keyword> else </keyword>',
      opening_non_terminal_element: '<ifStatement>',
      closing_non_terminal_element: '</ifStatement>',
    },
    {
      keyword: '<keyword> while </keyword>',
      opener: '<symbol> { </symbol>',
      closer: '<symbol> } </symbol>',
      opening_non_terminal_element: '<whileStatement>',
      closing_non_terminal_element: '</whileStatement>',
    },
  ]

  non_terminal_elements.each do |non_terminal_element|
    elements_indexes = find_elements_indexes(non_terminal_element, tokenized_lines)

    elements_indexes.each do |indexes|
      tokenized_lines = apply_non_terminal_element(tokenized_lines, indexes, non_terminal_element)

      # recalculating index positions since we are adding more lines for the non_terminal_elements
      elements_indexes.each_with_index do |i, index_of_i|
        elements_indexes[index_of_i][:open] += 1 if i[:open] > indexes[:open]
        elements_indexes[index_of_i][:open] += 1 if i[:open] > indexes[:close]
        elements_indexes[index_of_i][:close] += 1 if i[:close] > indexes[:open]
        elements_indexes[index_of_i][:close] += 1 if i[:close] > indexes[:close]
      end

      if body = non_terminal_element[:additional_subroutine_body]
        additional_indexes = { close: indexes[:close] }

        tokenized_lines.each_with_index do |line, index|
          next unless index > indexes[:open]

          if line.include?(body[:opener])
            additional_indexes[:open] = index
            break
          end
        end

        tokenized_lines = apply_non_terminal_element(tokenized_lines, additional_indexes, non_terminal_element[:additional_subroutine_body])

        elements_indexes.each_with_index do |i, index_of_i|
          elements_indexes[index_of_i][:open] += 1 if i[:open] > additional_indexes[:open]
          elements_indexes[index_of_i][:open] += 1 if i[:open] > additional_indexes[:close]
          elements_indexes[index_of_i][:close] += 1 if i[:close] > additional_indexes[:open]
          elements_indexes[index_of_i][:close] += 1 if i[:close] > additional_indexes[:close]
        end
      end
    end
  end

  return tokenized_lines
end

def apply_non_terminal_element(tokenized_lines, indexes, non_terminal_element)

  line_after = tokenized_lines[indexes[:close] + 1]
  offset = line_after ? line_after.split('<').first : ''

  tokenized_lines.insert(indexes[:close] + 1, "#{offset}#{non_terminal_element[:additional_offset]}#{non_terminal_element[:closing_non_terminal_element]}")
  tokenized_lines.insert(indexes[:open], "#{offset}#{non_terminal_element[:additional_offset]}#{non_terminal_element[:opening_non_terminal_element]}")

  tokenized_lines.each_with_index do |tl, index|
    # we inserted at :close + 1 BUT we also inserted at :open so it's +2, not +1
    next unless index > indexes[:open] && index < indexes[:close] + 2
    tokenized_lines[index] = "  #{tl}"
  end

  return tokenized_lines
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

def apply_basic_expressions(tokenized_lines)
  expressions = [
    {
      keyword: '<keyword> do </keyword>',
      opener: '<symbol> ( </symbol>',
      closer: '<symbol> ) </symbol>',
      opening_element: '<expressionList>',
      closing_element: '</expressionList>',
    },
    {
      keyword: '<symbol> . </symbol>',
      additional_keyword: '<identifier> new </identifier>',
      opener: '<symbol> ( </symbol>',
      closer: '<symbol> ) </symbol>',
      opening_element: '<expressionList>',
      closing_element: '</expressionList>',
    },
    {
      keyword: '<keyword> let </keyword>',
      opener: '<symbol> = </symbol>',
      closer: '<symbol> ; </symbol>',
      opening_element: '<expression>',
      closing_element: '</expression>',
    },
    { # not 100% sure about this one
      keyword: '<symbol> / </symbol>',
      opener: '<symbol> ( </symbol>',
      closer: '<symbol> ) </symbol>',
      opening_element: '<expression>',
      closing_element: '</expression>',
    },
    {
      keyword: '<keyword> if </keyword>',
      opener: '<symbol> ( </symbol>',
      closer: '<symbol> ) </symbol>',
      opening_element: '<expression>',
      closing_element: '</expression>',
    },
    {
      keyword: '<keyword> while </keyword>',
      opener: '<symbol> ( </symbol>',
      closer: '<symbol> ) </symbol>',
      opening_element: '<expression>',
      closing_element: '</expression>',
    },
    {
      keyword: '<symbol> [ </symbol>',
      opener: '<symbol> [ </symbol>',
      closer: '<symbol> ] </symbol>',
      opening_element: '<expression>',
      closing_element: '</expression>',
    },
    {
      keyword: '<keyword> return </keyword>',
      opener: '<keyword> return </keyword>',
      closer: '<symbol> ; </symbol>',
      opening_element: '<expression>',
      closing_element: '</expression>',
    },
    {
      keyword: '<symbol> * </symbol>',
      opener: '<symbol> ( </symbol>',
      closer: '<symbol> ) </symbol>',
      opening_element: '<expression>',
      closing_element: '</expression>',
    },
  ]

  expressions.each do |expression|
    elements_indexes = find_elements_indexes_for_expression(expression, tokenized_lines)

    # Applying the expressions
    elements_indexes.each do |indexes|
      next if expression[:additional_keyword] && !tokenized_lines[indexes[:open] - 1].include?(expression[:additional_keyword])
      next if indexes[:close] == indexes[:open] + 1 && expression[:keyword] == '<keyword> return </keyword>'

      line_after = tokenized_lines[indexes[:close]]
      offset = line_after.split('<').first || ''
      tokenized_lines.insert(indexes[:close], "#{offset}#{expression[:closing_element]}")
      tokenized_lines.insert(indexes[:open] + 1, "#{offset}#{expression[:opening_element]}")

      # Applying an offset between expressions
      ((indexes[:open] + 2)..(indexes[:close])).each do |index|
        tokenized_lines[index] = "  #{tokenized_lines[index]}"
      end
    end
  end

  return tokenized_lines
end

def apply_nested_expressions(tokenized_lines)
  expression = {
    keyword: '<keyword> do </keyword>',
    opener: '<expressionList>',
    closer: '</expressionList>'
  }
  indexes = find_elements_indexes_for_expression(expression, tokenized_lines)

  # finding all indexes of expressionList
  indexes.each do |index_pair|
    next if index_pair[:close] == index_pair[:open] + 1
    commas = []
    tokenized_lines.each_with_index do |tl, index|
      next unless index > index_pair[:open] && index < index_pair[:close]
      # applying offset in advance
      tokenized_lines[index] = "  #{tl}" unless TERMS_SEPARATORS.any?{|ts|tl.include?(ts)}
      # finding all commas between expressionList
      commas << index if TERMS_SEPARATORS.any?{|ts|tl.include?(ts)}
    end
    commas = commas.sort!.reverse! # bottom up so as to avoir recalculating indexes

    offset = tokenized_lines[index_pair[:close]].split('<').first

    # inserting
    tokenized_lines.insert(index_pair[:close], "#{offset}  </expression>")
    commas.each do |comma|
      tokenized_lines.insert(comma + 1, "#{offset}  <expression>")
      tokenized_lines.insert(comma, "#{offset}  </expression>")
    end
    tokenized_lines.insert(index_pair[:open] + 1, "#{offset}  <expression>")
  end

  return tokenized_lines
end

def apply_terms(tokenized_lines)
  expression = {
    keyword: '<expression>',
    opener: '<expression>',
    closer: '</expression>'
  }

  indexes = find_elements_indexes(expression, tokenized_lines)

  indexes.each do |i|
    nested = indexes.select {|i2| i2[:close] < i[:close] && i2[:open] > i[:open] }
    next if nested.empty?
    # We already sorted indexes by [:open], so we start by the nested expression
    # If there is a nested expression, we need to add +2 to the [:close] index
    # of the nestING expression, because we will add two lines for the nestED one
    nested.each { |_nested| i[:close] += 2 }
  end

  # finding all indexes of expressionList
  indexes.each do |index_pair|
    next if index_pair[:close] == index_pair[:open] + 1
    commas = []
    tokenized_lines.each_with_index do |tl, index|
      next unless index > index_pair[:open] && index < index_pair[:close]
      # applying offset in advance
      tokenized_lines[index] = "  #{tl}" unless TERMS_SEPARATORS.any?{|ts|tl.include?(ts)}
      # finding all commas between expressionList
      commas << index if TERMS_SEPARATORS.any?{|ts|tl.include?(ts)}
    end
    commas = commas.sort!.reverse! # bottom up so as to avoir recalculating indexes

    offset = tokenized_lines[index_pair[:close]].split('<').first

    # inserting
    tokenized_lines.insert(index_pair[:close], "#{offset}  </term>")
    commas.each do |comma|
      tokenized_lines.insert(comma + 1, "#{offset}  <term>")
      tokenized_lines.insert(comma, "#{offset}  </term>")
    end
    tokenized_lines.insert(index_pair[:open] + 1, "#{offset}  <term>")
  end

  return tokenized_lines
end

def apply_specific_minus_terms(tokenized_lines)
  terms = [
    {
      opener: '<symbol> = </symbol>',
      opener_bis: '<symbol> ( </symbol>',
      closer: '<symbol> - </symbol>',
      closer_bis: '<symbol> ; </symbol>'
    }
  ]

  terms_indexes = []

  terms.each do |term|
    opened = false
    open_close_count = 0
    open_close_count_bis = 0
    potential_index = nil
    tokenized_lines.each_with_index do |tl, index|
      if tl.include?(term[:opener])
        open_close_count += 1
        opened = true
      elsif tl.include?(term[:opener_bis]) && opened
        open_close_count_bis += 1
      elsif tl.include?(term[:closer]) && open_close_count > 0 && opened
        potential_index = index
        open_close_count -= 1
      elsif tl.include?(term[:closer_bis]) && open_close_count_bis > 0 && opened
        open_close_count_bis -= 1
        if open_close_count == 0 && open_close_count_bis == 0
          terms_indexes << potential_index
          potential_index = nil
        end
      elsif tl.include?(term[:closer_bis])
        opened = false
        open_close_count = 0
        open_close_count_bis = 0
        potential_index = nil
      end
    end
  end

  terms_indexes.sort!.reverse!.each do |term_index|
    offset = tokenized_lines[term_index].split('<').first
    tokenized_lines.insert(term_index + 2, "#{offset}</term>")
    tokenized_lines.insert(term_index + 1, "#{offset}<term>")
    tokenized_lines[term_index + 2] = "  #{tokenized_lines[term_index + 2]}"
  end

  return tokenized_lines
end

def find_elements_indexes(non_terminal_element, tokenized_lines)
  elements_indexes = []

  tokenized_lines.each_with_index do |line, index|
    if line.include?(non_terminal_element[:keyword])
      elements_indexes << { open: index, open_close_count: 0 }
    end

    # getting the latest opening element
    current_element = elements_indexes.select { |e| !e[:close] }.sort_by { |e|e[:open] }.last

    if line.include?(non_terminal_element[:opener]) && current_element
      current_element[:open_close_count] += 1

    elsif line.include?(non_terminal_element[:closer]) && current_element &&
      (
        (!non_terminal_element[:next_line_cancelling_one_closer]) ||
        (!tokenized_lines[index + 1].include?(non_terminal_element[:next_line_cancelling_one_closer]))
      )
      current_element[:open_close_count] -= 1

      if current_element[:open_close_count] == 0
        current_element[:close] = index
      end
    end
  end

  return elements_indexes.map{|e|{open: e[:open], close: e[:close]}}.sort_by{|e|e[:open]}.reverse!
end

def find_elements_indexes_for_expression(expression, tokenized_lines)
  elements_indexes = []
  current_element_index = {}
  open_close_count = 0
  start_expression = false

  # For each expression, find the indexes at which applying them
  tokenized_lines.each_with_index do |line, index|
    if line.include?(expression[:keyword])
      open_close_count = 0
      start_expression = true
    end

    if line.include?(expression[:opener]) && start_expression
      open_close_count += 1
      current_element_index[:open] = index if open_close_count == 1
    elsif line.include?(expression[:closer]) && start_expression
      open_close_count -= 1
      if open_close_count == 0
        current_element_index[:close] = index
        elements_indexes << current_element_index
        current_element_index = {}
        start_expression = false
      end
    end
  end

  return elements_indexes.sort_by!{|i|i[:open]}.reverse!
end

def translate_jack_file_content(jack_file, xml_file, testing_tokenizer_only)
  tokenized_lines = []

  sanitized_lines(jack_file).each do |line|
    tokenized_lines << generate_tokenized_lines(line)
  end

  if !testing_tokenizer_only
    tokenized_lines = apply_parameters_lists(tokenized_lines)
    tokenized_lines = apply_non_terminal_elements(tokenized_lines)
    tokenized_lines = apply_statements(tokenized_lines)
    tokenized_lines = apply_basic_expressions(tokenized_lines)
    tokenized_lines = apply_nested_expressions(tokenized_lines)
    tokenized_lines = apply_terms(tokenized_lines)
    tokenized_lines = apply_specific_minus_terms(tokenized_lines)
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
  test_file_lines = File.open(test_file_name).each_line.to_a
  xml_file_lines = File.open(xml_file_name).each_line.to_a

  xml_file_lines.each_with_index do |line, index|
    next if line.delete("\r\n") == test_file_lines[index].delete("\r\n")
    break p "Discrepancy found on line #{index + 1} : #{line} ---------- vs ---------- #{test_file_lines[index]}"
  end
end
