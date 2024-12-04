import gleam/int

// import gleam/io
import gleam/list
import gleam/option.{type Option, Some}
import gleam/regexp
import simplifile

pub const regex1 = "mul\\(([0-9]{1,3}),([0-9]{1,3})\\)"

// TODO: only the most recent do() or don't() applies !
pub const regex2 = "don't\\(\\).*?(?:do\\(\\)|$)"

fn parse_submatch(submatch: Option(String)) -> Int {
  case submatch {
    Some(string) -> {
      let assert Ok(integer) = int.parse(string)
      integer
    }
    _ -> panic as { "Can't parse submatch" }
  }
}

fn parse_match(match: regexp.Match) -> #(Int, Int) {
  let assert [a, b] = match.submatches

  #(parse_submatch(a), parse_submatch(b))
}

pub fn parse_part1(filepath: String) -> List(#(Int, Int)) {
  let assert Ok(re1) = regexp.from_string(regex1)

  case simplifile.read(from: filepath) {
    Ok(text) -> regexp.scan(re1, text) |> list.map(parse_match)
    Error(_) -> panic as { "Can't open " <> filepath }
  }
}

fn parse_chunk(re: regexp.Regexp, chunk: String) -> List(#(Int, Int)) {
  // io.debug("__________________________________________________")
  // io.debug(chunk)
  regexp.scan(re, chunk) |> list.map(parse_match)
}

pub fn parse_part2(filepath: String) -> List(#(Int, Int)) {
  let assert Ok(re1) = regexp.from_string(regex1)
  let assert Ok(re2) = regexp.from_string(regex2)

  case simplifile.read(from: filepath) {
    Ok(text) -> regexp.split(re2, text) |> list.flat_map(parse_chunk(re1, _))
    Error(_) -> panic as { "Can't open " <> filepath }
  }
}
