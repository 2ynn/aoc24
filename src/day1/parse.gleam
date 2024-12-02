import gleam/int
import gleam/list
import gleam/string
import simplifile

const separator: String = "   "

fn to_int(string: String) -> Int {
  let assert Ok(integer) = string |> int.parse
  integer
}

fn parse_line(line: String) -> Result(#(Int, Int), Nil) {
  case line {
    "" -> Error(Nil)
    string -> {
      case string |> string.split(separator) {
        [first, second] -> {
          Ok(#(first |> to_int, second |> to_int))
        }
        _ -> panic as { "Unexpected format: " <> line }
      }
    }
  }
}

pub fn parse_file(filepath: String) -> #(List(Int), List(Int)) {
  case simplifile.read(from: filepath) {
    Ok(text) -> {
      text
      |> string.split("\n")
      |> list.filter_map(parse_line)
      |> list.unzip
    }
    Error(_) -> {
      panic as { "Can't open " <> filepath }
    }
  }
}
