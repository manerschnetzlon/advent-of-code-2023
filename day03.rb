# frozen_string_literal: true

file = File.open('inputs/input_day03.txt')
file_array = file.read.split("\n")

class Day3
  def initialize(input)
    @input = input
    @numbers = []
    @part_numbers = []
    @stars = []
  end

  def resolve
    parse_schema
    # print_schema
    find_numbers_and_stars
    find_part_numbers
    p "part1: #{sum_part_numbers}"
    find_gears
    p "part2: #{compute_gears}"
  end

  private

  def parse_schema
    @schema = @input.map { |line| line.split('') }
    @schema.insert(0, Array.new(@schema.first.count, '.'))
    @schema.insert(-1, Array.new(@schema.first.count, '.'))
    @schema.each do |line|
      line.insert(0, '.')
      line.insert(-1, '.')
    end
  end

  def find_numbers_and_stars
    position = []
    number = ''
    @schema.each_with_index do |line, y|
      line.each_with_index do |char, x|
        @stars << [x, y] if char == '*'
        if ('0'..'9').include?(char)
          number += char
          position << [x, y]
        elsif number != ''
          @numbers << [number, position]
          number = ''
          position = []
        end
      end
    end
  end

  def find_part_numbers
    @numbers.each do |number, position|
      @part_numbers << number if position.any? do |p|
        around_positions(p).any? { |a_p| symbol?(a_p) }
      end
    end
  end

  def around_positions(position)
    x, y = position
    [[x - 1, y], [x + 1, y],
     [x, y - 1], [x, y + 1],
     [x - 1, y - 1], [x - 1, y + 1],
     [x + 1, y - 1], [x + 1, y + 1]]
  end

  def symbol?(position)
    x, y = position
    char = @schema[y][x]
    non_symbol = ('0'..'9').to_a + ['.']
    !non_symbol.include?(char)
  end

  def print_schema
    @schema.each do |line|
      puts line.join('')
    end
  end

  def sum_part_numbers
    @part_numbers.map(&:to_i).sum
  end

  def find_gears
    @gears = []
    @stars.each do |star|
      gear = []
      @numbers.each do |number, position|
        around_numbers = position.map { |p| around_positions(p) }
        gear << number.to_i if around_numbers.any? { _1.include?(star) }
      end
      @gears << gear
    end
  end

  def compute_gears
    @gears.filter_map do |gear|
      next if gear.count != 2

      gear.reduce(&:*)
    end.sum
  end
end

Day3.new(file_array).resolve
