import gleam/int
// import gleam/io
import gleam/list
import gleam/regexp
import gleam/option.{type Option, Some}
import gleam/string
import simplifile

pub const regex1 = "mul\\(([0-9]{1,3}),([0-9]{1,3})\\)"

fn regex2() -> List(regexp.Regexp) {
  let do = "do\\(\\)"
  let dont = "don't\\(\\)"
  let no_dont = fmt("((?!{0}).)", [dont])

  ["(?:^|{0})({2}+?)(?:{1}|$)"]
  |> list.map(fn(r) {
    let assert Ok(re) =
      fmt(r, [do, dont, no_dont])
      // |> io.debug
      |> regexp.from_string
    re
  })
}

/// Basic string interpolation
fn fmt(string: String, substitutes: List(String)) -> String {
  case substitutes {
    [] -> string
    subs ->
      list.index_fold(
        subs,
        string,
        fn(string: String, item: String, index: Int) {
          let pattern = "{" <> int.to_string(index) <> "}"
          string.replace(string, pattern, item)
        },
      )
  }
}

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

fn parse_chunk(re: regexp.Regexp, chunk: regexp.Match) -> List(#(Int, Int)) {
  // io.debug("____________________________")
  // io.debug(chunk)
  regexp.scan(re, chunk.content) |> list.map(parse_match)
}

pub fn parse_part2(filepath: String) -> List(#(Int, Int)) {
  let input = case simplifile.read(from: filepath) {
    Ok(text) -> text
    Error(_) -> panic as { "Can't open " <> filepath }
  }

  let assert Ok(re1) = regexp.from_string(regex1)

  let parse = fn(re, text) {
    regexp.scan(re, text)
    |> list.flat_map(parse_chunk(re1, _))
  }

  regex2() |> list.flat_map(parse(_, input))
}
