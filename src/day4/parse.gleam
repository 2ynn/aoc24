// import gleam/io
import gleam/bool
import gleam/list
import gleam/string
import simplifile

pub type Position =
  #(Int, Int)

pub type Chars =
  List(#(Position, String))

/// Panics if a given condition is met, otherwise returns False.
pub fn panic_if(when cond: Bool, message msg: String) -> Bool {
  bool.guard(bool.negate(cond), False, fn() { panic as msg })
}

pub fn parse_line(content: String, width: Int, line: Int) -> Chars {
  case content {
    "" -> []
    _ -> {
      let graphemes = string.to_graphemes(content)
      panic_if(
        list.length(graphemes) != width,
        "Inconsistent line width: " <> content,
      )

      let position = fn(col) { #(col, line) }
      list.index_map(graphemes, fn(string, j) { #(position(j), string) })
    }
  }
}

pub fn parse_file(filepath: String) -> Chars {
  let lines = case simplifile.read(from: filepath) {
    Error(_) -> panic as { "Can't open " <> filepath }
    Ok(text) -> string.split(text, "\n") |> list.filter(fn(l) { l != "" })
  }

  let assert [first, ..] = lines
  let width = string.length(first)

  list.index_map(lines, fn(string, i) { parse_line(string, width, i) })
  |> list.flatten
}
