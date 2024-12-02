import gleam/int

import day1/parse.{parse_file}
import gleam/io
import gleam/list
import gleam/order

pub fn run() {
  let #(sorted1, sorted2) = part0("data/day1/input.txt")

  io.debug("Total distance: " <> { part1(sorted1, sorted2) |> int.to_string })

  io.debug("Similarity score: " <> { part2(sorted1, sorted2) |> int.to_string })
}

pub fn part0(filename: String) -> #(List(Int), List(Int)) {
  let #(l1, l2) = parse_file(filename)
  #(l1 |> list.sort(by: int.compare), l2 |> list.sort(by: int.compare))
}

pub fn part1(l1: List(Int), l2: List(Int)) -> Int {
  list.zip(l1, l2)
  |> list.fold(0, fn(b, a) { b + distance(a) })
}

pub fn part2(l1: List(Int), l2: List(Int)) {
  l1
  |> list.fold(0, fn(b, a) { b + similarity(a, with: l2) })
}

fn distance(tup: #(Int, Int)) -> Int {
  tup.1 - tup.0 |> int.absolute_value
}

fn similarity(a: Int, with l: List(Int)) -> Int {
  let is_similar = fn(b: Int) {
    case int.compare(a, b) {
      order.Eq -> True
      _ -> False
    }
  }

  a * { l |> list.filter(is_similar) |> list.length }
}
