# frozen_string_literal: true

file = File.open('inputs/input_day01.txt')
file_array = file.read.split("\n")

def compact_and_sum(array)
  array.map do |part|
    "#{part.first}#{part.last}".to_i
  end.sum
end

def part1(input)
  new_array = input.map do |line|
    line.chars.select do |char|
      ('0'..'9').include?(char)
    end
  end

  compact_and_sum(new_array)
end

def part2(input)
  numbers = %w[one two three four five six seven eight nine]

  new_array = input.map do |line|
    i = 0
    new_line = []
    line.chars.each_with_index do |char, index|
      break unless (part = line[i..index])

      new_line << char.to_i if ('0'..'9').include?(char)

      num = numbers.find { part.include?(_1) }
      if num
        new_line << numbers.index(num) + 1
        i += part.length - 1
      end
    end
    new_line
  end

  compact_and_sum(new_array)
end

p "result part1: #{part1(file_array)}"
p "result part2: #{part2(file_array)}"
