# frozen_string_literal: true

file = File.open('inputs/input_day07.txt')
file_array = file.read.split("\n")

class Type
  attr_reader :configuration_value

  def initialize(configuration)
    @configuration = configuration
    @configuration_value = Type.configurations.index(configuration)
  end

  def self.configurations
    %w[
      high_card
      one_pair
      two_pairs
      three_of_a_kind
      full_house
      four_of_a_kind
      five_of_a_kind
    ]
  end
end

class Card
  attr_reader :value

  def initialize(label)
    @label = label
    @value = %w[0 1 2 3 4 5 6 7 8 9 T J Q K A].index(label)
  end
end

class Hand
  attr_reader :type, :cards, :bid
  attr_accessor :rank

  def initialize(cards, bid)
    @cards = cards
    @bid = bid
    @type = determine_type
    @rank = nil
  end

  private

  def determine_type
    counts = @cards.map do |card|
      @cards.map(&:value).count(card.value)
    end

    if counts.include?(5)
      Type.new('five_of_a_kind')
    elsif counts.include?(4)
      Type.new('four_of_a_kind')
    elsif counts.uniq.sort == [2, 3]
      Type.new('full_house')
    elsif counts.include?(3)
      Type.new('three_of_a_kind')
    elsif counts.count(2) == 4
      Type.new('two_pairs')
    elsif counts.count(2) == 2
      Type.new('one_pair')
    else
      Type.new('high_card')
    end
  end
end

class CamelCardsGame
  def initialize(input)
    @input = input
    @hands = []
    parse_input
    set_ranks
  end

  def resolve
    part1 = @hands.map do |hand|
      hand.rank * hand.bid
    end.sum
    p "Part 1: #{part1}"
  end

  private

  def parse_input
    @input.each do |line|
      hand, bid = line.split
      cards = hand.split('').map { |card| Card.new(card) }
      @hands << Hand.new(cards, bid.to_i)
    end
  end

  def set_ranks
    order_hands

    @hands_sorted.flatten.each_with_index do |hand, index|
      hand.rank = index + 1
    end
  end

  def order_hands
    order_hands_by_type
    order_hands_for_same_type
  end

  def order_hands_by_type
    @hands_by_type = @hands
                     .group_by { |hand| hand.type.configuration_value }
                     .sort_by { |_, value| value.first.type.configuration_value }
                     .map(&:last)
  end

  def order_hands_for_same_type
    @hands_sorted = @hands_by_type.map do |type|
      type.sort_by! do |hand|
        hand.cards.map!(&:value)
      end
    end
  end
end

CamelCardsGame.new(file_array).resolve
