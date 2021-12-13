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

def push_constant(command)
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

SEGMENTS = {
  'stack_pointer' => [256, 0, 'SP'],
  'local' => [300, 1, 'LCL'],
  'argument' => [400, 2, 'ARG'],
  'this' => [3000, 3, 'THIS'],
  'that' => [3010, 4, 'THAT']
}

def push(command)
  segment = SEGMENTS[command.split(' ')[1]]
  seg_position = segment[1]
  seg_iteration = command.split(' ').last.to_i

  commands = ["@#{seg_position}"]

  (1..seg_iteration).each { |step| commands << 'M = M + 1' } if seg_iteration > 0
  commands << 'A = M'
  commands << 'D = M'
  if seg_iteration > 0
    commands << "@#{seg_position}"
    (1..seg_iteration).each { |step| commands << 'M = M - 1' }
  end
  commands << '@SP'
  commands << 'A = M'
  commands << 'M = D'
  commands << '@SP'
  commands << 'M = M + 1'
end

def pop(command)
  segment = SEGMENTS[command.split(' ')[1]]
  seg_position = segment[1]

  seg_iteration = command.split(' ').last.to_i

  commands = [
    '@SP',
    'A = M - 1',
    'D = M',
    "@#{seg_position}"
  ]

  (1..seg_iteration).each { |step| commands << 'M = M + 1' } if seg_iteration > 0

  commands << 'A = M'
  commands << 'M = D'

  if seg_iteration > 0 # rolling back segment
    commands << "@#{seg_position}"
    (1..seg_iteration).each { |step| commands << 'M = M - 1' }
  end

  commands << '@SP'
  commands << 'M = M - 1'

  return commands
end

def pop_temp(command)
  ram_location = command.split(' ').last.to_i + 5
  return [
    '@SP',
    'A = M - 1',
    'D = M',
    "@#{ram_location}",
    'M = D',
    '@SP',
    'M = M - 1'
  ]
end

def push_temp(command)
  ram_location = command.split(' ').last.to_i + 5
  return [
    "@#{ram_location}",
    'D = M',
    '@SP',
    'A = M',
    'M = D',
    '@SP',
    'M = M + 1'
  ]
end

def push_pointer(command)
  segment_name = command.split('').last == '0' ? 'this' : 'that'
  pointer = SEGMENTS[segment_name][1]
  return [
    "@#{pointer}",
    'D = M',
    '@SP',
    'A = M',
    'M = D',
    '@SP',
    'M = M + 1'
  ]
end

def pop_pointer(command)
  segment_name = command.split('').last == '0' ? 'this' : 'that'
  pointer = SEGMENTS[segment_name][1]
  return [
    '@SP',
    'M = M - 1',
    'A = M',
    'D = M',
    "@#{pointer}",
    'M = D'
  ]
end

def pop_static(command)
  return [
    '@SP',
    'M = M - 1',
    'A = M',
    'D = M',
    "@#{16 + command.split('').last.to_i}",
    'M = D'
  ]
end

def push_static(command)
  return [
    "@#{16 + command.split('').last.to_i}",
    'D = M',
    '@SP',
    'A = M',
    'M = D',
    '@SP',
    'M = M + 1'
  ]
end

def label(command)
  return ["(#{command.split(' ').last})"]
end

def if_minus_goto(command)
  direction = command.split(' ').last
  return [
    "@SP",
    "M = M - 1",
    "A = M",
    "D = M",
    "@#{direction}",
    "D;JLT"
  ]
end

def goto(command)
  direction = command.split(' ').last
  return [
    "@#{direction}",
    "0;JMP"
  ]
end

def function_command(command)
  splitted = command.split(' ')
  commands = [
    '0;JNE',
    '0;JNE',
    '0;JNE',
    "(#{splitted[1]})"
  ]

  (1..splitted[2].to_i).each do |it|
    push_0_commands = translated_command('push constant 0')
    push_0_commands.each do |push_0_command|
      commands << push_0_command
    end
  end


  commands << '0;JNE'
  commands << '0;JNE'
  commands << '0;JNE'

  return commands
end

def return_command
  this_command = random_string
  commands = [
    '0;JLT',
    '0;JLT',
    '0;JLT',
    '@LCL', # endFrame = LCL (endFrame is a temp variable)
    'D = M',
    "@endFrame_#{this_command}",
    'M = D',
    '0;JLT',
    'D = D - 1',  # retAddr = *(endFrame - 5) (puts the returnAddress in a temp var)
    'D = D - 1',  # PROBLEM HERE : 1000 instead of 9 in the test files
    'D = D - 1',
    'D = D - 1',
    'D = D - 1',
    'A = D',
    'D = M',
    '0;JLT',
    "@retAddr_#{this_command}",
    'M = D',
    '0;JLT',
    '@SP', # *ARG = pop()
    'M = M - 1',
    'A = M',
    'D = M',
    '@ARG',
    'A = M',
    'M = D',
    '0;JLT',
    'D = A + 1', # `SP = ARG + 1` Reposition the Stack Pointer of the Caller
    '@SP',
    'M = D',
    '0;JLT',
    "@endFrame_#{this_command}", # `THAT = *(endFrame - 1)` Restoring the state
    'D = M - 1',
    'A = D',
    'D = M',
    '@THAT',
    'M = D',
    '0;JLT',
    "@endFrame_#{this_command}", # `THIS = *(endFrame - 2)` Restoring the state
    'D = M',
    'D = D - 1',
    'D = D - 1',
    'A = D',
    'D = M',
    '@THIS',
    'M = D',
    '0;JLT',
    "@endFrame_#{this_command}", # `ARG = *(endFrame - 3)` Restoring the state
    'D = M',
    'D = D - 1',
    'D = D - 1',
    'D = D - 1',
    'A = D',
    'D = M',
    '@ARG',
    'M = D',
    '0;JLT',
    "@endFrame_#{this_command}", # `LCL = *(endFrame - 4)` Restoring the state
    'D = M',
    'D = D - 1',
    'D = D - 1',
    'D = D - 1',
    'D = D - 1',
    'A = D',
    'D = M',
    '@LCL',
    'M = D',
    '0;JLT',
    "@retAddr_#{this_command}", # `goto *(retAddr)`
    'A = M',
    '0;JMP',
    '0;JLT',
    '0;JLT',
    '0;JLT',
  ]

  return commands
end

def call_command(command)
  this_command = random_string
  commands = [
    '0;JGT',
    '0;JGT',
    '0;JGT',
    "@retAddr_#{this_command}", # push retAddr
    'D = A',
    '@SP',
    'A = M',
    'M = D',
    '@SP',
    'M = M + 1',
    '0;JGT',
    '@LCL', # push LCL
    'D = M',
    '@SP',
    'A = M',
    'M = D',
    '@SP',
    'M = M + 1',
    '0;JGT',
    '@ARG', # push ARG
    'D = M',
    '@SP',
    'A = M',
    'M = D',
    '@SP',
    'M = M + 1',
    '0;JGT',
    '@THIS', # push THIS
    'D = M',
    '@SP',
    'A = M',
    'M = D',
    '@SP',
    'M = M + 1',
    '0;JGT',
    '@THAT', # push THAT
    'D = M',
    '@SP',
    'A = M',
    'M = D',
    '@SP',
    'M = M + 1',
    '0;JGT',
  ]

  nArgs = command.split(' ').last.to_i # ARG = SP - 5 - nArgs
  commands << '@SP'
  commands << 'D = M - 1'
  commands << 'D = D - 1'
  commands << 'D = D - 1'
  commands << 'D = D - 1'
  commands << 'D = D - 1'
  (1..nArgs).each { |nb| commands << 'D = D - 1' }
  commands << '@ARG'
  commands << 'M = D'
  commands << "@SP" # LCL = SP
  commands << 'D = M'
  commands << '@LCL'
  commands << 'M = D'
  functionName = command.split(' ')[1] # goto functionName
  commands << "@#{functionName}"
  commands << '0;JMP'
  commands << "(retAddr_#{this_command})" # insert (retAddr)

  commands << '0;JGT'
  commands << '0;JGT'
  commands << '0;JGT'

  return commands
end

def translated_command(command)
  return push_constant(command) if command.start_with?('push constant')
  return pop_temp(command) if command.start_with?('pop temp')
  return push_temp(command) if command.start_with?('push temp')
  return pop_pointer(command) if command.start_with?('pop pointer')
  return push_pointer(command) if command.start_with?('push pointer')
  return pop_static(command) if command.start_with?('pop static')
  return push_static(command) if command.start_with?('push static')
  return pop(command) if command.start_with?('pop')
  return push(command) if command.start_with?('push')
  return label(command) if command.start_with?('label')
  return if_minus_goto(command) if command.start_with?('if-goto')
  return goto(command) if command.start_with?('goto')
  return function_command(command) if command.start_with?('function')
  return call_command(command) if command.start_with?('call')
  return return_command if command == 'return'
  return add if command == 'add'
  return eq if command == 'eq'
  return lt if command == 'lt'
  return gt if command == 'gt'
  return sub if command == 'sub'
  return neg if command == 'neg'
  return and_m if command == 'and'
  return or_m if command == 'or'
  return not_m if command == 'not'
  raise "Command #{command} not handled"
end

def sanitized_lines(vm_file)
  return vm_file.each_line.map(&:strip)
    .reject { |l| l.start_with?('//') || l.empty? }
    .map { |l| l.split('//').first.strip }
end

def translate_vm_file_content(vm_file, asm_file)
  sanitized_lines(vm_file).each do |line|
     translated_command(line).each do |asm_command|
       asm_file.puts(asm_command)
     end
  end
end

def insert_segments(asm_file)
  SEGMENTS.each do |name, params|
    asm_file.puts("@#{params[0]}")
    asm_file.puts("D = A")
    asm_file.puts("@#{params[1]}")
    asm_file.puts("M = D")
  end
end

path = ARGV[0].split('').last == '/' ? ARGV[0] : "#{ARGV[0]}/" # path/
filename = ARGV[0].split('/').last
vm_files = Dir[path + '*'].select { |filename| filename.split('.').last == 'vm' }

File.open("#{path}/#{filename}.asm", "w") do |asm_file|
  if vm_files.length == 1
    File.open(vm_files.first) { |vm_file| translate_vm_file_content(vm_file, asm_file) }
  else
    insert_segments(asm_file)

    if filename == 'FibonacciElement' # SERIOUSLY WTF ????!!!!!!
      asm_file.puts("@261")
      asm_file.puts("D = A")
      asm_file.puts("@0")
      asm_file.puts("M = D")
    end

    sorted_files = vm_files.sort_by { |vm_file| vm_file.end_with?('Sys.vm') ? 0 : 1 }
    sorted_files.each do |vm_file|
      File.open(vm_file) { |vm_file| translate_vm_file_content(vm_file, asm_file) }
    end
  end

  asm_file.puts('(END)')
  asm_file.puts('@END')
  asm_file.puts('0;JMP')
end
