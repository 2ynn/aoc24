import day6/day6
import day6/parse.{parse_map}

import gleam/dict
import gleam/set
import gleeunit/should

pub fn day6_test() {
  let map = parse_map("data/day6/test.txt")
  should.equal(dict.size(map), 100)

  let trail = day6.part1(map)
  should.equal(dict.size(trail), 41)

  let blockers = day6.part2(map)
  let expected = [#(6, 3), #(7, 6), #(7, 7), #(8, 3), #(8, 1), #(9, 7)]
  should.equal(blockers, set.from_list(expected))
}
