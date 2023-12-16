# frozen_string_literal: true

file = File.open('inputs/input_day08.txt')
raw_instructions, raw_nodes = file.read.split("\n\n")

def part1(raw_instructions:, raw_nodes:)
  instructions = parsed_instructions(raw_instructions:)
  nodes = parsed_nodes(raw_nodes:)
  steps = count_steps(nodes:, instructions:)

  p "Part 1: #{steps}"
end

def parsed_instructions(raw_instructions:)
  raw_instructions.chars
end

def parsed_nodes(raw_nodes:)
  pattern = /([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)/
  nodes_hash = {}
  raw_nodes.split("\n").each do |node|
    match_data = node.match(pattern)
    nodes_hash[match_data[1]] = { 'L' => match_data[2], 'R' => match_data[3] }
  end
  nodes_hash
end

def count_steps(instructions:, nodes:)
  current_node, end_node = 'AAA', 'ZZZ'
  steps = 0

  while current_node != end_node
    instructions.each do |instruction|
      steps += 1
      current_node = nodes[current_node][instruction]
      break steps if current_node == end_node
    end
  end

  steps
end

part1(raw_instructions:, raw_nodes:)
