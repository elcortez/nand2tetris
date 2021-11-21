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
    "D;JGT"
  ]
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

def insert_segments(asm_file)
  SEGMENTS.each do |name, params|
    asm_file.puts("@#{params[0]}")
    asm_file.puts("D = A")
    asm_file.puts("@#{params[1]}")
    asm_file.puts("M = D")
  end
end

def insert_ending(asm_file)
   asm_file.puts('(END)')
   asm_file.puts('@END')
   asm_file.puts('0;JMP')
end

def translate_vm_file_content(vm_file, asm_file)
  vm_file.each_line.map(&:strip).reject { |l| l.start_with?('//') || l.empty? }.each do |line|
     translated_command(line).each do |asm_command|
       asm_file.puts(asm_command)
     end
  end
end

path = ARGV[0]
filename = ARGV[0].split('/').last
vm_files = Dir[path + '*'].select { |filename| filename.split('.').last == 'vm' }

File.open("#{path}/#{filename}.asm", "w") do |asm_file|
  insert_segments(asm_file)

  if vm_files.length == 1
    File.open(vm_files.first) { |vm_file| translate_vm_file_content(vm_file, asm_file) }
  else
    # raise si pas de Sys.vm
    # commencer par le Sys.vm
    # Traduire les fonctions en fonction du moment où elles sont appelées ?
    raise "File length #{vm_files.length} not supported"
  end

  insert_ending(asm_file)
end