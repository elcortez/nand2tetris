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

def translated_line(line)
  lines = []
  string_started = false
  temp_string = []
  splitted = line.split(/\s(?!\")/)
    .map { |string|string.split(/(\.)|(\{)|(\})|(\[)|(\])|(\()|(\))|(\,)|(\;)|(\+)|(\-)|(\*)|(\/)|(\&)|(\|)|(\>)|(\<)|(\=)|(\~)/) }
    .flatten
    .reject { |s|s == '' }

  splitted.each do |word|
    if word.start_with?('"') # ORDER IS IMPORTANT
      string_started = true
      temp_string << word.split('"').join('')
    elsif word.end_with?('"') # ORDER IS IMPORTANT
      string_started = false
      temp_string << word.split('"').join('')
      lines << "<stringConstant> #{temp_string.join(' ')} </stringConstant>"
      temp_string = []
    elsif string_started # ORDER IS IMPORTANT
      temp_string << word.split('"').join('')
    elsif is_integer(word)
      lines << "<integerConstant> #{word} </integerConstant>"
    elsif XML_IDENTIFIERS.keys.include?(word)
      lines << "<symbol> #{XML_IDENTIFIERS[word]} </symbol>"
    elsif SYMBOLS.include?(word)
      lines << "<symbol> #{word} </symbol>"
    elsif KEYWORDS.include?(word)
      lines << "<keyword> #{word} </keyword>"
    else # ORDER IS IMPORTANT
      lines << "<identifier> #{word} </identifier>"
    end
  end
  return [lines]
end

def sanitized_lines(jack_file)
  return jack_file.each_line.map(&:strip)
    .reject { |l| l.start_with?('//') ||  l.start_with?('/*') || l.empty? }
    .map { |l| l.split('//').first.strip }
end

def translate_jack_file_content(jack_file, xml_file)
  sanitized_lines(jack_file).each do |line|
     translated_line(line).each do |xml_command|
       xml_file.puts(xml_command)
     end
  end
end

folders = ARGV[0].split('/')

if folders.last.end_with?('.jack')
  path = folders[0..-2].join('/')
  filename = folders[-2]
  jack_files = Dir[path + '/*'].select { |filename| filename.split('.').last == 'jack' }
else
  path = ARGV[0].split('').last == '/' ? ARGV[0] : "#{ARGV[0]}/" # path/
  filename = folders.last
  jack_files = Dir[path + '*'].select { |filename| filename.split('.').last == 'jack' }
end

File.open("#{path}/#{filename}.xml", "w") do |xml_file|
  xml_file.puts('<tokens>')
  if jack_files.length == 1
    File.open(jack_files.first) { |jack_file| translate_jack_file_content(jack_file, xml_file) }
  else
    jack_files.each do |jack_file|
      File.open(jack_file) { |jack_file| translate_jack_file_content(jack_file, xml_file) }
    end
  end
  xml_file.puts('</tokens>')
end


test_file = File.open(ARGV[0]).each_line.to_a.map(&:strip)

File.open(ARGV[0]).each_line.to_a.map(&:strip).each_with_index do |line, index|
  next if line == test_file[index]
  p "Discrepancy found on line #{index}"
end

p 'Test successful !'
