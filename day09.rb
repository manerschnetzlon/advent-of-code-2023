# frozen_string_literal: true

file = File.open('inputs/input_day09.txt')
file_array = file.read.split("\n")

histories = file_array.map(&:split).map { _1.map(&:to_i) }

def resolve(histories)
  sequences = []
  histories.each { |history| sequences << find_sequences(history) }
  predictions_part1 = sequences.map { |sequence| extrapolate_part1(sequence) }
  predictions_part2 = sequences.map { |sequence| extrapolate_part2(sequence) }
  p "part1: #{predictions_part1.map { _1.last.last }.sum}"
  p "part2: #{predictions_part2.map { _1.last.first }.sum}"
end

def find_sequences(sequence)
  sequences = [sequence]
  while sequence.uniq != [0]
    sequence = sequence.each_cons(2).map { |a, b| (b - a) }
    sequences << sequence
  end
  sequences
end

def extrapolate_part1(sequence)
  sequence = sequence.reverse
  num = 0
  sequence.map do |seq|
    seq << seq[-1] + num
    num = seq[-1]
  end
  sequence
end

def extrapolate_part2(sequence)
  sequence = sequence.reverse
  num = 0
  sequence.map do |seq|
    seq.prepend(seq[0] - num)
    num = seq[0]
  end
  sequence
end

resolve(histories)
