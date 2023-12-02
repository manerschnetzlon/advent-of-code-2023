# frozen_string_literal: true

file = File.open('inputs/input_day02.txt')
file_array = file.read.split("\n")

class Cube
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class SetGame
  attr_accessor :cubes

  def initialize(game)
    @cubes = []
    @game = game
  end

  def valid?
    red_valid? && blue_valid? && green_valid?
  end

  def color_cubes(color)
    @cubes.select { _1.color == color }
  end

  private

  def red_valid?
    color_cubes('red').count <= 12
  end

  def blue_valid?
    color_cubes('blue').count <= 14
  end

  def green_valid?
    color_cubes('green').count <= 13
  end
end

class Game
  attr_accessor :sets
  attr_reader :id

  def initialize(id)
    @id = id
    @sets = []
  end

  def valid?
    @sets.all?(&:valid?)
  end

  def max_color(color)
    @sets.map { _1.color_cubes(color).count }.max
  end
end

class Day2
  def initialize(input)
    @input = input
    @games = []
  end

  def resolve
    create_games
    resolve_part1
    resolve_part2
  end

  def resolve_part1
    p "part1: #{@games.select(&:valid?).map(&:id).sum}"
  end

  def resolve_part2
    result = @games.map do |game|
      game.max_color('red') * game.max_color('blue') * game.max_color('green')
    end
    p "part2: #{result.sum}"
  end

  private

  def find_game(id)
    @games.find { _1.id == id }
  end

  def create_games
    @input.each do |line|
      id = line.scan(/Game (?<id>\d+)/).flatten.first.to_i
      game = Game.new(id)
      @games << game
      line.gsub!(/Game \d+: /, '')
      create_set(line, game)
    end
  end

  def create_set(line, game)
    sets = line.split('; ')
    sets.each do |s|
      set = SetGame.new(game)
      s.split(', ').each do |cubes|
        quantity = cubes.scan(/\d+/).flatten.first.to_i
        color = cubes.scan(/[a-z]+/).flatten.first
        set.cubes << create_cubes(quantity, color)
        set.cubes.flatten!
      end
      game.sets << set
    end
  end

  def create_cubes(quantity, color)
    cubes = []
    quantity.times do
      cubes << Cube.new(color)
    end
    cubes
  end
end

Day2.new(file_array).resolve
