import gleam/int
import gleam/list
import gleam/string
import simplifile

const separator: String = " "

fn to_int(string: String) -> Int {
  let assert Ok(integer) = int.parse(string)
  integer
}

fn parse_line(line: String) -> Result(List(Int), Nil) {
  case line {
    "" -> Error(Nil)
    str -> Ok(str |> string.split(separator) |> list.map(to_int))
  }
}

pub fn parse_file(filepath: String) -> List(List(Int)) {
  case simplifile.read(from: filepath) {
    Ok(text) -> {
      text
      |> string.split("\n")
      |> list.filter_map(parse_line)
    }
    Error(_) -> {
      panic as { "Can't open " <> filepath }
    }
  }
}
