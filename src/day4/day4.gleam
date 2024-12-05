import day4/parse.{type Chars, type Position, parse_file}

import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn run() {
  let filename = "data/day4/input.txt"
  let chars = parse_file(filename)

  io.debug("Number of XMAS: " <> { part1(chars) |> int.to_string })
}

pub type Orientation {
  Horizontal
  Vertical
  Slash
  BackSlash
}

pub type Direction {
  Forward
  Backward
}

pub type Offset =
  parse.Position

pub type Offsets =
  List(Offset)

pub fn offsets(orientation: Orientation, direction: Direction) -> Offsets {
  list.map(list.range(1, 3), offset(orientation, direction, _))
}

pub fn offset(
  orientation: Orientation,
  direction: Direction,
  distance: Int,
) -> Offset {
  let offset = case orientation {
    Horizontal -> #(1, 0)
    Vertical -> #(0, 1)
    Slash -> #(1, 1)
    BackSlash -> #(-1, 1)
  }

  let offset = case direction {
    Forward -> offset
    Backward -> offset |> fn(o) { #(-o.0, -o.1) }
  }

  #(int.multiply(distance, offset.0), int.multiply(distance, offset.1))
}

pub fn part1(chars: Chars) -> Int {
  let orientations = [Horizontal, Vertical, Slash, BackSlash]
  let directions = [Forward, Backward]

  list.flat_map(orientations, fn(o) {
    list.map(directions, fn(d) { scan(chars, offsets(o, d)) })
  })
  |> list.fold(0, fn(b, a) { b + a })
}

pub fn scan(chars: Chars, offsets: Offsets) -> Int {
  io.debug("scanning...")
  list.map(chars, fn(c) {
    let #(pos, char) = c
    use <- bool.guard(char != "X", 0)
    search_at_position(chars, offsets, pos)
  })
  |> list.fold(0, fn(b, a) { b + a })
}

pub fn search_at_position(
  chars: Chars,
  offsets: Offsets,
  position: Position,
) -> Int {
  let mas =
    list.map(offsets, fn(offset) {
      let offset_position = #(position.0 + offset.0, position.1 + offset.1)
      get_char_at_position(chars, offset_position)
    })
    |> string.concat

  case mas == "MAS" {
    True -> 1
    False -> 0
  }
}

pub fn get_char_at_position(chars: Chars, pos: Position) -> String {
  case list.key_find(chars, pos) {
    Ok(char) -> char
    Error(_) -> "_"
  }
}
