import day5/day5
import day5/parse.{parse_ruleset, parse_updates}
import gleam/dict
import gleam/list
import gleeunit/should

pub fn day5_test() {
  let ruleset = parse_ruleset("data/day5/test/rules.txt")
  let updates = parse_updates("data/day5/test/updates.txt")

  should.equal(dict.size(ruleset), 7)
  should.equal(list.length(updates), 6)

  should.equal(day5.part1(updates, ruleset), 143)
}
