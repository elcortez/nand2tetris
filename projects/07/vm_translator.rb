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

def or
end

def not
end

def eq
  # 0 if not equal, -1 if equal
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M - D',
    '@EQ',
    'D;JEQ',
    '@NOT_EQ',
    'D;JNE',
    '(EQ)',
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = -1',
    '@END',
    '0;JMP',
    '(NOT_EQ)',
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = 0',
    '@END',
    '0;JMP',
  ]
end

def lt
  # 0 if not lower, -1 if lower
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M - D',
    '@LT',
    'D;JLT',
    '@NOT_LT',
    'D;JGE',
    '(LT)',
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = -1',
    '@END',
    '0;JMP',
    '(NOT_LT)',
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = 0',
    '@END',
    '0;JMP',
  ]
end

def gt
  # 0 if not greater, -1 if greater
  [
    '@SP',
    'A = M - 1',
    'D = M',
    'A = A - 1',
    'D = M - D',
    '@GT',
    'D;JGT',
    '@NOT_GT',
    'D;JLE',
    '(GT)',
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = -1',
    '@END',
    '0;JMP',
    '(NOT_GT)',
    '@SP',
    'A = M - 1',
    'A = A - 1',
    'M = 0',
    '@END',
    '0;JMP',
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
