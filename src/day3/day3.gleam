import day3/parse.{parse_part1, parse_part2}

import gleam/int
import gleam/io
import gleam/list

pub fn run() {
  let filename = "data/day3/input.txt"
  io.debug("Addition result: " <> { part1(filename) |> int.to_string })

  io.debug("Adjusted result: " <> { part2(filename) |> int.to_string })
  // 86741683 | 83596704 | 46382221
}

fn compute(operands: List(#(Int, Int))) -> Int {
  // io.debug(
  //   "Computing " <> { operands |> list.length |> int.to_string } <> " commands",
  // )
  list.fold(operands, 0, fn(b, t) { b + t.0 * t.1 })
}

pub fn part1(filename: String) -> Int {
  parse_part1(filename) |> compute
}

pub fn part2(filename: String) -> Int {
  parse_part2(filename) |> compute
}
