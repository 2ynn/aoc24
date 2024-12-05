import day4/parse.{type Chars, type Position, parse_file}

import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn run() {
  let filename = "data/day4/input.txt"
  let chars = parse_file(filename)
  io.debug("Number of XMAS (part1): " <> { part1(chars) |> int.to_string })
  io.debug("Number of X-MAS (part2): " <> { part2(chars) |> int.to_string })
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

// PART 1
pub fn part1(chars: Chars) -> Int {
  let orientations = [Horizontal, Vertical, Slash, BackSlash]
  let directions = [Forward, Backward]

  list.flat_map(orientations, fn(o) {
    list.map(directions, fn(d) { search1(chars, offsets1(o, d)) })
  })
  |> list.fold(0, fn(b, a) { b + a })
}

fn offsets1(orientation: Orientation, direction: Direction) -> Offsets {
  list.map(list.range(1, 3), offset1(orientation, direction, _))
}

fn offset1(
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

fn search1(chars: Chars, offsets: Offsets) -> Int {
  // io.debug("scan (1) ...")
  list.map(chars, fn(c) {
    let #(pos, char) = c
    use <- bool.guard(char != "X", 0)
    { get_word_at_position(chars, pos, offsets) == "MAS" } |> bool.to_int
  })
  |> list.fold(0, int.add)
}

// PART 2
pub fn part2(chars: Chars) -> Int {
  let x_offsets = list.map([Slash, BackSlash], offsets2)

  // io.debug("scan (2) ...")
  list.map(chars, fn(c) {
    let #(pos, char) = c
    use <- bool.guard(char != "A", 0)

    list.map(x_offsets, fn(offsets) {
      let ms = get_word_at_position(chars, pos, offsets)
      bool.or(ms == "MS", ms == "SM")
    })
    |> list.fold(True, bool.and)
    |> bool.to_int
  })
  |> list.fold(0, int.add)
}

fn offsets2(orientation: Orientation) -> Offsets {
  case orientation {
    Slash -> [#(-1, -1), #(1, 1)]
    BackSlash -> [#(1, -1), #(-1, 1)]
    _ -> panic as { "Invalid orientation." }
  }
}

// UTILS
fn get_word_at_position(
  chars: Chars,
  position: Position,
  offsets: Offsets,
) -> String {
  list.map(offsets, fn(offset) {
    get_char_at_position(chars, get_offset_position(position, offset))
  })
  |> string.concat
}

fn get_offset_position(position: Position, offset: Offset) {
  #(position.0 + offset.0, position.1 + offset.1)
}

fn get_char_at_position(chars: Chars, pos: Position) -> String {
  case list.key_find(chars, pos) {
    Ok(char) -> char
    Error(_) -> "_"
  }
}
