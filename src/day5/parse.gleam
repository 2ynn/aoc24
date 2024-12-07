import day5/types.{
  type Index, type Page, type PageNumber, type Pages, type Predicate,
  type RuleSet, type Updates,
}
import gleam/dict.{get, has_key, insert}
import gleam/int
import gleam/list
import gleam/order
import gleam/string
import simplifile
import utils.{panic_if}

fn before(i: Index, j: Index) -> Bool {
  int.compare(i, j) == order.Lt
}

fn after(i: Index, j: Index) -> Bool {
  int.compare(i, j) == order.Gt
}

fn update_rules(
  ruleset: RuleSet,
  ruleset_key: PageNumber,
  rule_key: PageNumber,
  predicate: Predicate,
) -> RuleSet {
  let updated_rules = case get(ruleset, ruleset_key) {
    Ok(rules) -> {
      case has_key(rules, rule_key) {
        True -> panic as { "Duplicate rule found " }
        False -> rules |> insert(rule_key, predicate)
      }
    }
    Error(_) -> dict.new() |> insert(rule_key, predicate)
  }

  ruleset |> insert(ruleset_key, updated_rules)
}

fn parse_rules(ruleset: RuleSet, line: String) -> RuleSet {
  let assert [Ok(p1), Ok(p2)] = string.split(line, "|") |> list.map(int.parse)

  ruleset |> update_rules(p1, p2, before) |> update_rules(p2, p1, after)
}

pub fn parse_ruleset(filename: String) -> RuleSet {
  parse_file(filename) |> list.fold(dict.new(), parse_rules)
}

fn index_page(number: PageNumber, index: Index) -> Page {
  #(index, number)
}

fn parse_pages(line: String) -> Pages {
  let page_numbers =
    string.split(line, ",")
    |> list.map(fn(s) {
      let assert Ok(n) = int.parse(s)
      n
    })

  panic_if(list.length(page_numbers) % 2 != 1, "Expected odd number of pages")

  list.index_map(page_numbers, index_page)
}

pub fn parse_updates(filename: String) -> Updates {
  list.map(parse_file(filename), parse_pages)
}

fn parse_file(filepath: String) -> List(String) {
  case simplifile.read(from: filepath) {
    Error(_) -> panic as { "Can't open " <> filepath }
    Ok(text) -> string.split(text, "\n") |> list.filter(fn(l) { l != "" })
  }
}
