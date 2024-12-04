import day2/day2.{part1, part2}
import day2/parse.{parse_file}
import gleeunit/should

pub fn day2_test() {
  let reports = parse_file("data/day2/test.txt")
  let safe = part1(reports)
  let tolerable = part2(reports)

  should.equal(safe, 2)

  should.equal(safe + tolerable, 4)
}
