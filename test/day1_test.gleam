import day1/day1.{part0, part1, part2}
import gleeunit/should

pub fn day1_test() {
  let #(sorted1, sorted2) = part0("data/day1/test.txt")

  should.equal(sorted1, [1, 2, 3, 3, 3, 4])
  should.equal(sorted2, [3, 3, 3, 4, 5, 9])

  should.equal(part1(sorted1, sorted2), 11)
  should.equal(part2(sorted1, sorted2), 31)
}
