import day6/day6
import day6/parse.{parse_map}

// import gleam/int
// import gleam/io
import gleam/dict
import gleeunit/should

pub fn day6_test() {
  let map = parse_map("data/day6/test.txt")

  should.equal(dict.size(map), 100)

  should.equal(day6.part1(map), 41)
  // should.equal(day5.part2(updates, ruleset), 123)
}
