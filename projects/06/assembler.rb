def self.is_a_instruction?(instruction)
  instruction.start_with?('@') && is_number?(nb(instruction))
end

def self.nb(instruction)
  instruction.split('@')[1]
end

def self.is_number?(string)
  true if Float(string) rescue false
end

def self.sanitized_instructions(file)
  file.each_line.map(&:strip).reject{|l| l.start_with?('//') || l.empty? }
end

def self.translate_dest(dest)
  translator = {
    nil => '000',
    'M' => '001',
    'D' => '010',
    'MD' => '011',
    'A' => '100',
    'AM' => '101',
    'AD' => '110',
    'AMD' => '111'
  }

  return translator[dest]
end

def self.translate_comp(comp)
  translator = {
    '0' => '0101010',
    '1' => '0111111',
    '-1' => '0111010',
    'D' => '0001100',
    'A' => '0110000',
    'M' => '1110000',
    '!D' => '0001111',
    '!A' => '0110001',
    '!M' => '1110001',
    '-D' => '0001111',
    '-A' => '0110011',
    '-M' => '1110011',
    'D+1' => '0011111',
    'A+1' => '0110111',
    'M+1' => '1110111',
    'D-1' => '0001110',
    'A-1' => '0110010',
    'M-1' => '1110010',
    'D+A' => '0000010',
    'D+M' => '1000010',
    'D-A' => '0010011',
    'D-M' => '1010011',
    'A-D' => '0000111',
    'M-D' => '1000111',
    'D&A' => '0000000',
    'D&M' => '1000000',
    'D|A' => '0010101',
    'D|M' => '1010101'
  }

  return translator[comp]
end

def translate_jump(jump)
  translator = {
    nil => '000',
    'JGT' => '001',
    'JEQ' => '010',
    'JGE' => '011',
    'JLT' => '100',
    'JNE' => '101',
    'JLE' => '110',
    'JMP' => '111'
  }

  return translator[jump]
end

def self.a_instruction(instruction)
  '%016i' % nb(instruction).to_i.to_s(2)
end

def self.c_instruction(instruction)
  if instruction.include?('=')
    delimiters = ['=', ';']
    instructions = instruction.split(Regexp.union(delimiters))
  else
    instructions = instruction.split(';').unshift(nil)
  end

  return [
    '111',
    translate_comp(instructions[1]),
    translate_dest(instructions[0]),
    translate_jump(instructions[2])
  ].join('')
end


File.open("#{ARGV[0].sub('asm', 'hack')}", "w") do |hack_file|
  File.open(ARGV[0]) do |asm_file|
    self.sanitized_instructions(asm_file).each do |instruction|

      if self.is_a_instruction?(instruction)
        hack_file.puts(a_instruction(instruction))
      else
        hack_file.puts(c_instruction(instruction))
      end
    end
  end
end
