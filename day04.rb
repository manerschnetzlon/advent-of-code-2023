# frozen_string_literal: true

file = File.open('inputs/input_day04.txt')
file_array = file.read.split("\n")

class Card
  attr_reader :id, :score, :wins, :copies

  def initialize(id:, winning_numbers:, numbers:)
    @id = id
    @winning_numbers = winning_numbers
    @numbers = numbers
    @wins = []
    @score = 0
    @copies = []
  end

  def find_winning_numbers
    @wins = @numbers & @winning_numbers
  end

  def compute_score
    @score = @wins.empty? ? 0 : 1
    @wins.count.times do |t|
      next if t.zero?

      @score *= 2
    end
  end

  def compute_copies
    return if @wins.empty?

    wins.count.times do |t|
      @copies << (id + t + 1)
    end
  end
end

class Day4
  def initialize(input)
    @input = input
    @cards = []
    @hash = {}
    @total_scratchcards = []
  end

  def resolve
    init
    p "part1: #{part1}"
    p "part2: #{part2}"
  end

  private

  def init
    create_cards
    find_wins
  end

  def part1
    @cards.each(&:compute_score).map(&:score).sum
  end

  def part2
    find_copies
    @cards.each do |card|
      @total_scratchcards << card.id
      find_scratchcards(card)
    end
    @total_scratchcards.count
  end

  def create_cards
    pattern = /Card(\s+)(?<id>\d+):(?<winning_numbers>((\s*)(\d+)(\s*))+)\|(?<numbers>((\s*)(\d+)(\s*))+)|/
    @input.each do |line|
      match_data = line.match(pattern)
      id = match_data[:id].to_i
      winning_numbers = match_data[:winning_numbers].split.map(&:to_i)
      numbers = match_data[:numbers].split.map(&:to_i)
      @cards << Card.new(id:, winning_numbers:, numbers:)
    end
  end

  def find_wins
    @cards.each(&:find_winning_numbers)
  end

  def find_copies
    @cards.each(&:compute_copies)
  end

  def find_scratchcards(card)
    return if card.copies.empty?

    card.copies.each do |copy|
      @total_scratchcards << copy
      card = @cards.find { |c| c.id == copy }
      find_scratchcards(card)
    end
  end
end

Day4.new(file_array).resolve
