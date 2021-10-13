def random_string
  (0...8).map { (65 + rand(26)).chr }.join
end

def add
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M + D',
    'M = D',
    '@SP',
    'M = M - 1'
  ]
end

def sub
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M - D',
    'M = D',
    '@SP',
    'M = M - 1'
  ]
end

def neg
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'M = M - D',
    'M = M -D'
  ]
end

def and_m
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M & D',
    'M = D',
    '@SP',
    'M = M - 1'
  ]
end

def or_m
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M | D',
    'M = D',
    '@SP',
    'M = M - 1'
  ]
end

def not_m
  [
    '@SP',
    'A = M - 1',
    'D = -M',
    'M = D - 1'
  ]
end

def gt
  # 0 if not greater, -1 if greater
  this_method = random_string
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M - D',
    "@GT_#{this_method}",
    'D;JGT',
    "@NOT_GT_#{this_method}",
    'D;JLE',
    "(GT_#{this_method})",
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = -1',
    '@SP',
    'M = M - 1',
    "@END_#{this_method}",
    '0;JMP',
    "(NOT_GT_#{this_method})",
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = 0',
    '@SP',
    'M = M - 1',
    "@END_#{this_method}",
    '0;JMP',
    "(END_#{this_method})"
  ]
end

def lt
  # 0 if not lower, -1 if lower
  this_method = random_string
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M - D',
    "@LT_#{this_method}",
    'D;JLT',
    "@NOT_LT_#{this_method}",
    'D;JGE',
    "(LT_#{this_method})",
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = -1',
    '@SP',
    'M = M - 1',
    "@END_#{this_method}",
    '0;JMP',
    "(NOT_LT_#{this_method})",
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = 0',
    '@SP',
    'M = M - 1',
    "@END_#{this_method}",
    '0;JMP',
    "(END_#{this_method})"
  ]
end

def eq
  # 0 if not equal, -1 if equal
  this_method = random_string
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M - D',
    "@EQ_#{this_method}",
    'D;JEQ',
    "@NOT_EQ_#{this_method}",
    'D;JNE',
    "(EQ_#{this_method})",
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = -1',
    '@SP',
    'M = M - 1',
    "@END_#{this_method}",
    '0;JMP',
    "(NOT_EQ_#{this_method})",
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = 0',
    '@SP',
    'M = M - 1',
    "@END_#{this_method}",
    '0;JMP',
    "(END_#{this_method})"
  ]
end

def translated_push_command(command)
  splitted = command.split(' ')
  raise "Wrong push command #{splitted}" unless splitted.length == 3
  [
    "@#{splitted.last}",
    'D = A',
    '@SP',
    'A = M',
    'M = D',
    '@SP',
    'M = M + 1'
  ]
end

def translated_command(command)
  return translated_push_command(command) if command.start_with?('push')
  return add if command == 'add'
  return eq if command == 'eq'
  return lt if command == 'lt'
  return gt if command == 'gt'
  return sub if command == 'sub'
  return neg if command == 'neg'
  return and_m if command == 'and'
  return or_m if command == 'or'
  return not_m if command == 'not'
  return []
end

File.open("#{ARGV[0].sub('vm', 'asm')}", "w") do |asm_file|
  File.open(ARGV[0]) do |vm_file|
    if ARGV[0].include?('PersonalTest') # setting stack pointer on my own tests
      asm_file.puts("@256")
      asm_file.puts("D = A")
      asm_file.puts("@0")
      asm_file.puts("M = D")
    end

    vm_file.each_line.map(&:strip).reject { |l| l.start_with?('//') || l.empty? }.each do |line|
      translated_command(line).each do |asm_command|
        asm_file.puts(asm_command)
      end
    end

    asm_file.puts('(END)')
    asm_file.puts('@END')
    asm_file.puts('0;JMP')
  end
end
