import day6/types.{type Col, type Map, type Row, type Tile}
import gleam/dict.{insert}
import gleam/list
import gleam/string
import simplifile
import utils.{panic_if}

pub fn parse_map(filepath: String) -> Map {
  let lines = case simplifile.read(from: filepath) {
    Error(_) -> panic as { "Can't open " <> filepath }
    Ok(text) -> string.split(text, "\n") |> list.filter(fn(l) { l != "" })
  }

  let assert [first, ..] = lines
  let width = string.length(first)

  list.index_map(lines, fn(s, i) { parse_line(s, i, width) })
  |> list.flatten
  |> list.fold(dict.new(), fn(m, tile) { insert(m, tile.pos, tile.pix) })
}

fn parse_line(line content: String, on row: Row, with width: Int) -> List(Tile) {
  let graphemes = string.to_graphemes(content)
  panic_if(
    list.length(graphemes) != width,
    "Inconsistent line width: " <> content,
  )

  list.index_map(graphemes, fn(char, col) { parse_tile(char, row, col) })
}

fn parse_tile(char: String, row: Row, col: Col) -> Tile {
  let pixel = case char {
    "." -> types.Empty
    "#" -> types.Block
    "^" -> types.Start
    string -> panic as { "Unexpected character " <> string }
  }

  types.Tile(pos: #(row, col), pix: pixel)
}
