import day4/day4
import day4/parse.{parse_file}
import gleam/list
import gleeunit/should

pub fn day4_test() {
  let filename = "data/day4/test.txt"

  let chars = parse_file(filename)
  should.equal(list.length(chars), 100)
  should.equal(day4.part1(chars), 18)
}
