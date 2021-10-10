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
  return []
end

File.open("#{ARGV[0].sub('vm', 'asm')}", "w") do |asm_file|
  File.open(ARGV[0]) do |vm_file|
    vm_file.each_line.map(&:strip).reject { |l| l.start_with?('//') || l.empty? }.each do |line|
      translated_command(line).each do |asm_command|
        asm_file.puts(asm_command)
      end
    end
  end
end
