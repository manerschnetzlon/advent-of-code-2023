# frozen_string_literal: true

file = File.open('inputs/input_day06.txt')
file_array = file.read.split("\n")

class Race
  attr_reader :time, :record_distance, :winning_options

  def initialize(time:, record_distance:)
    @time = time
    @record_distance = record_distance
    @winning_options = 0
    find_options
  end

  def find_options
    (1..time).each do |t|
      @winning_options += 1 if t * (time - t) > record_distance
    end
  end
end

class Day6
  def initialize(input)
    @input = input
    @races = []
  end

  def resolve
    p "part1: #{part1}"
    p "part2: #{part2}"
  end

  private

  def reset_races
    @races = []
  end

  def create_races_part1
    input = @input.map(&:split).each(&:shift)
    input.first.length.times do |i|
      time = input[0][i].to_i
      record_distance = input[1][i].to_i
      @races << Race.new(time:, record_distance:)
    end
  end

  def create_race_part2
    input = @input.map(&:split).each(&:shift)
    input = input.map(&:join)
    @races << Race.new(time: input[0].to_i, record_distance: input[1].to_i)
  end

  def part1
    reset_races
    create_races_part1
    @races.map(&:winning_options).reduce(:*)
  end

  def part2
    reset_races
    create_race_part2
    @races.map(&:winning_options).reduce(:*)
  end
end

Day6.new(file_array).resolve
