class JackAnalyzer
  KEYWORDS = ['class', 'method', 'function', 'constructor', 'int', 'boolean',
              'char', 'void', 'var', 'static', 'field', 'let', 'do', 'if',
              'else', 'while', 'return', "true", 'false', 'null', 'this']


  SEGMENTS = { 'static'=>'static', 'field'=>'this', 'argument'=>'argument', 'local'=>'local' }
  KEYWORD_REGEX = KEYWORDS.map{|k|k+'(?=\s)'}.join('|')
  ID_REGEX = '[a-zA-Z_]\w*'
  NB_REGEX = '\d+'
  STRING_REGEX = '"[^"\n]*"'
  SYMBOLS = '{}()[].,;+-*/&|<>=~'
  SYMBOL_REGEX = '['+Regexp.escape(SYMBOLS)+']'
  WORD_REGEX = Regexp.new(KEYWORD_REGEX+'|'+ID_REGEX+'|'+SYMBOL_REGEX+'|'+NB_REGEX+'|'+STRING_REGEX)

  def initialize(jack_file)
    @file = File.open(jack_file)

    @symbols = { 'static' => {}, 'field' => {}, 'argument' => {}, 'local' => {} }
    @symbols_indexes = { 'static' => 0, 'field' => 0, 'argument' => 0, 'local' => 0 }
    @label_num = 0

    @sanitized_lines = sanitize_lines
    @tokens = @sanitized_lines.map{|l| l.scan(WORD_REGEX)}.flatten.reverse
    @final_lines = []
  end

  def sanitize_lines
    multiline_comment_started = false

    return @file.each_line.map(&:strip).reject do |l|
      multiline_comment_started = true if l.start_with?('/*')
      multiline_comment_started = false if l.end_with?('*/')

      (l.start_with?('*') && multiline_comment_started == true) || l.start_with?('/*') || l.end_with?('*/') || l.start_with?('//') || l.empty?

    end.map { |l| l.split('//').first.strip }
  end

  def generate_lines
    @tokens.pop
    @class_name = @tokens.pop
    @tokens.pop
    while ['static', 'field'].include?(@tokens[-1])
      generate_lines_for_var_declaration(@tokens.pop)
    end

    while ['constructor', 'function', 'method'].include?(@tokens[-1])
      generate_lines_for_any_method
    end
    @tokens.pop
    return @final_lines
  end

  def generate_lines_for_var_declaration(kind)
    type = @tokens.pop
    name = @tokens.pop
    add_index_to_symbolic_table(name, type, kind)
    while [','].include?(@tokens[-1])
      @tokens.pop
      name = @tokens.pop
      add_index_to_symbolic_table(name, type, kind)
    end
    @tokens.pop
  end

  def generate_lines_for_any_method
    keyword = @tokens.pop
    @tokens.pop
    @method_name = @tokens.pop
    @symbols['local'].clear()
    @symbols_indexes['argument'] = 0
    @symbols_indexes['local'] = 0
    if keyword == 'method'
      add_index_to_symbolic_table('this', @class_name, 'argument')
    end
    @tokens.pop
    generate_lines_for_parameter_list()
    @tokens.pop
    generate_lines_for_any_method_body(keyword)
  end


  def add_index_to_symbolic_table(name, type, kind)
    @symbols[kind][name] = [type, kind, @symbols_indexes[kind]]
    @symbols_indexes[kind] += 1
  end

  def check_constant
    return ["true", 'false', 'null', 'this'].include?(@tokens[-1])  ||
      @tokens[-1].match(NB_REGEX) ||
      @tokens[-1].match(STRING_REGEX)
  end

  def get_symbolic_table_name(name)
    if @symbols['static'].include?(name)
      return @symbols['static'][name]
    elsif @symbols['field'].include?(name)
      return @symbols['field'][name]
    elsif @symbols['argument'].include?(name)
      return @symbols['argument'][name]
    elsif @symbols['local'].include?(name)
      return @symbols['local'][name]
    else
      return [nil, nil, nil]
    end
  end

  def vm_push(name)
    type, kind, index = get_symbolic_table_name(name)
    @final_lines << "push #{SEGMENTS[kind]} #{index}"
  end

  def generate_lines_for_parameter_list
    if @tokens[-1].match(ID_REGEX) || ['int', 'char', 'boolean'].include?(@tokens[-1])
      generate_lines_for_parameter
      while @tokens[-1] == ','
        @tokens.pop
        generate_lines_for_parameter
      end
    end
  end

  def generate_lines_for_parameter
    if @tokens[-1].match(ID_REGEX) || ['int', 'char', 'boolean'].include?(@tokens[-1])
      type = @tokens.pop
      name = @tokens.pop
      add_index_to_symbolic_table(name, type, 'argument')
    end
  end

  def generate_lines_for_any_method_body(keyword)
    @tokens.pop
    while @tokens[-1] == 'var'
      @tokens.pop
      generate_lines_for_var_declaration('local')
    end
    insert_func_decl(keyword)
    generate_lines_for_statements
    @tokens.pop
  end

  def insert_func_decl(keyword)
    @final_lines << "function #{@class_name}.#{@method_name} #{@symbols['local'].to_a.length}"
    if keyword == 'method'
      @final_lines << 'push argument 0'
      @final_lines << 'pop pointer 0'
    elsif keyword == 'constructor'
      @final_lines << "push constant #{@symbols['field'].to_a.length}"
      @final_lines << 'call Memory.alloc 1'
      @final_lines << 'pop pointer 0'
    end
  end

  def generate_lines_for_statements
    while ['let', 'if', 'while', 'do', 'return'].include?(@tokens[-1])
      generate_lines_for_let if @tokens[-1] == 'let'
      generate_lines_for_if if @tokens[-1] == 'if'
      generate_lines_for_while if @tokens[-1] == 'while'
      generate_lines_for_do if @tokens[-1] == 'do'
      generate_lines_for_return if @tokens[-1] == 'return'
    end
  end

  def generate_lines_for_let
    @tokens.pop
    name = @tokens.pop
    subscript = @tokens[-1] == '['
    generate_lines_for_base_plus_index(name) if subscript
    @tokens.pop
    generate_lines_for_expression
    @tokens.pop
    if subscript
      @final_lines << 'pop temp 1'
      @final_lines << 'pop pointer 1'
      @final_lines << 'push temp 1'
      @final_lines << 'pop that 0'
    else
      type, kind, index = get_symbolic_table_name(name)
      @final_lines << "pop #{SEGMENTS[kind]} #{index}"
    end
  end

  def generate_lines_for_base_plus_index(name)
    vm_push(name)
    @tokens.pop
    generate_lines_for_expression
    @tokens.pop
    @final_lines << 'add'
  end

  def generate_lines_for_if
    @tokens.pop
    end_label = "L#{@label_num += 1}"
    generate_lines_for_cond_expression_statements(end_label)
    if @tokens[-1] == 'else'
      @tokens.pop
      @tokens.pop
      generate_lines_for_statements
      @tokens.pop
    end
    @final_lines << "label #{end_label}"
  end

  def generate_lines_for_while
    @tokens.pop
    top_label = "L#{@label_num += 1}"
    @final_lines << "label #{top_label}"
    generate_lines_for_cond_expression_statements(top_label)
  end

  def generate_lines_for_cond_expression_statements(label)
    @tokens.pop
    generate_lines_for_expression
    @tokens.pop
    @final_lines << 'not'
    notif_label = "L#{@label_num += 1}"
    @final_lines << "if-goto #{notif_label}"
    @tokens.pop
    generate_lines_for_statements
    @tokens.pop
    @final_lines << "goto #{label}"
    @final_lines << "label #{notif_label}"
  end

  def generate_lines_for_do
    @tokens.pop
    name = @tokens.pop
    generate_lines_for_any_method_call(name)
    @final_lines << 'pop temp 0'
    @tokens.pop
  end

  def generate_lines_for_return
    @tokens.pop
    if @tokens[-1] != ';'
      generate_lines_for_expression
    else
      @final_lines << 'push constant 0'
    end

    @tokens.pop
    @final_lines << 'return'
  end

  def generate_lines_for_expression
    generate_lines_for_term
    vm_commands_translated = { '+'=>'add', '*'=>'call Math.multiply 2', '/'=>'call Math.divide 2', '-'=>'sub', '>'=>'gt', '<'=>'lt', '='=>'eq', '&'=>'and', '|'=>'or' }
    while ['+', '*', '/', '-', '&', '|', '>', '<', '='].include?(@tokens[-1])
      op = @tokens.pop
      generate_lines_for_term
      @final_lines << "#{vm_commands_translated[op]}"
    end
  end

  def generate_lines_for_term
    if check_constant
      val = @tokens.pop
      if val.match(NB_REGEX) && !val.match(STRING_REGEX)
        @final_lines << "push constant #{val}"
      elsif val.match(STRING_REGEX)
        insert_string_const_init(val)
      elsif KEYWORDS.include?(val)
        generate_lines_for_keyword_constant(val)
      end
    elsif @tokens[-1] == '('
      @tokens.pop
      generate_lines_for_expression
      @tokens.pop
    elsif ['-', '~'].include?(@tokens[-1])
      op = @tokens.pop
      generate_lines_for_term
      vm_operator = 'neg' if op == '-'
      vm_operator = 'not' if op == '~'
      @final_lines << vm_operator
    elsif @tokens[-1].match(ID_REGEX)
      name = @tokens.pop
      if @tokens[-1] == '['
        generate_lines_for_array_subscript(name)
      elsif ['(', '.'].include?(@tokens[-1])
        generate_lines_for_any_method_call(name)
      else
        vm_push(name)
      end
    end
  end

  def insert_string_const_init(val)
    val = val[1..-2] # removing unecessary quotes
    @final_lines << "push constant #{val.length}"
    @final_lines << 'call String.new 1'
    val.split('').each do |char|
      @final_lines << "push constant #{char.ord}"
      @final_lines << 'call String.appendChar 2'
    end
  end

  def generate_lines_for_keyword_constant(keyword)
    if keyword == 'this'
      @final_lines << 'push pointer 0'
    elsif keyword == 'true'
      @final_lines << 'push constant 1'
      @final_lines << 'neg'
    else
      @final_lines << 'push constant 0'
    end
  end


  def generate_lines_for_array_subscript(name)
    vm_push(name)
    @tokens.pop
    generate_lines_for_expression
    @tokens.pop
    @final_lines << 'add'
    @final_lines << 'pop pointer 1'
    @final_lines << 'push that 0'
  end

  def generate_lines_for_any_method_call(name)
    type, kind, index = self.get_symbolic_table_name(name)
    if @tokens[-1] == '.'
      num_args, name = self.generate_lines_for_dotted_subroutine_call(name, type)
    else
      num_args = 1
      @final_lines << 'push pointer 0'
      name = @class_name+'.'+name
    end
    @tokens.pop()
    num_args += self.generate_lines_for_expr_list()
    @tokens.pop()
    @final_lines << "call #{name} #{num_args}"
  end

  def generate_lines_for_dotted_subroutine_call(name, type)
    num_args = 0
    obj_name = name
    @tokens.pop
    name = @tokens.pop

    if ['int', 'char', 'boolean', 'void'].include?(type)
      raise 'Cannot use "." operator on builtin type'
    elsif type == nil
      name = obj_name + '.' + name
    else
      num_args = 1
      vm_push(obj_name) # push object ptr onto stack
      name = self.get_symbolic_table_name(obj_name)[0]+'.'+name
    end

    return num_args, name
  end

  def generate_lines_for_expr_list
    num_args = 0
    if check_constant or @tokens[-1].match(ID_REGEX) || @tokens[-1] == '(' || @tokens[-1] == '-~'
      generate_lines_for_expression
      num_args = 1
      while @tokens[-1] == ','
        @tokens.pop
        generate_lines_for_expression
        num_args += 1
      end
    end
    return num_args
  end
end

folder_path = ARGV[0].split('/')
directory = folder_path.last.end_with?('.jack') ? folder_path[0..-2] : folder_path
jack_files = Dir[directory.join('/') + '/*'].select { |filename| filename.split('.').last == 'jack' }
testing = ENV['USER'] == 'pierrehersant' # Testing only happens on my computer


jack_files.each do |jack_file|
  p "................ Compiling #{jack_file}"
  vm_file_name = jack_file.gsub(/.jack/, '.vm')

  File.open(vm_file_name, 'w') do |vm_file|
    analyzer = JackAnalyzer.new(jack_file)
    analyzer.generate_lines.each do |line|
      vm_file.puts(line)
    end
  end
end
