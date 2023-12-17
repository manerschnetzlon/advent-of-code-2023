# frozen_string_literal: true

file = File.open('inputs/input_day05.txt')
input = file.read.split("\n\n")

def part1(input)
  seeds = seeds(input[0])
  seed_to_oil_map = mapper(input[1], "seed-to-soil map:\n")
  soil_to_fertilizer = mapper(input[2], "soil-to-fertilizer map:\n")
  fertilizer_to_water = mapper(input[3], "fertilizer-to-water map:\n")
  water_to_light = mapper(input[4], "water-to-light map:\n")
  light_to_temperature = mapper(input[5], "light-to-temperature map:\n")
  temperature_to_humidity = mapper(input[6], "temperature-to-humidity map:\n")
  humidity_to_location = mapper(input[7], "humidity-to-location map:\n")

  categories = [seed_to_oil_map, soil_to_fertilizer, fertilizer_to_water, water_to_light, light_to_temperature, temperature_to_humidity, humidity_to_location]

  p "part1: #{find_lower_location(seeds, categories)}"
end

def seeds(seeds)
  pattern = /seeds: (.+)/
  seeds.match(pattern)[1].split.map(&:to_i)
end

def mapper(input, category)
  input
    .gsub(category, '')
    .split("\n")
    .map { _1.split.map(&:to_i) }
end

def map_number(number, mapper)
  mapper.each do |dest_start, source_start, length|
    if number >= source_start && number < source_start + length
      return dest_start + (number - source_start)
    end
  end

  number
end

def find_location(seed, categories)
  categories.reduce(seed) do |number, mapper|
    map_number(number, mapper)
  end
end

def find_lower_location(seeds, categories)
  seeds.map do |seed|
    find_location(seed, categories)
  end.min
end

part1(input)
