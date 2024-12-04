import day3/day3
import day3/parse.{parse_part1, parse_part2}
import gleam/list
import gleeunit/should

pub fn day3_test() {
  let f1 = "data/day3/test1.txt"
  should.equal(parse_part1(f1) |> list.length, 4)
  should.equal(day3.part1(f1), 161)

  let f2 = "data/day3/test2.txt"
  should.equal(parse_part2(f2) |> list.length, 2)
  should.equal(day3.part2(f2), 48)

  let f3 = "data/day3/test3.txt"
  should.equal(parse_part2(f3) |> list.length, 4)
  should.equal(day3.part2(f3), 75)
}
