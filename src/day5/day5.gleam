import day5/parse.{parse_ruleset, parse_updates}
import day5/types.{type Page, type RuleSet, type Update, type Updates}
import gleam/bool
import gleam/dict.{get}
import gleam/int.{to_string}
import gleam/io
import gleam/list

pub fn run() {
  let ruleset = parse_ruleset("data/day5/input/rules.txt")
  let updates = parse_updates("data/day5/input/updates.txt")

  io.debug(
    "Added mid numbers (part1): " <> { part1(updates, ruleset) |> to_string },
  )
}

fn get_other_pages(in update: Update, other_than page: Page) -> List(Page) {
  update |> list.filter(fn(p) { p != page })
}

fn check_update(update: Update, with ruleset: RuleSet) -> Bool {
  update
  |> list.map(fn(p) { check_page(p, get_other_pages(update, p), ruleset) })
  |> list.fold(True, bool.and)
}

fn check_page(
  page: Page,
  against other_pages: Update,
  with ruleset: RuleSet,
) -> Bool {
  case get(ruleset, page.1) {
    Error(_) -> {
      io.debug("No ruleset for " <> page.1 |> to_string)
      True
    }
    Ok(rules) -> {
      other_pages
      |> list.map(fn(other) {
        case get(rules, other.1) {
          Error(_) -> {
            io.debug(
              "No rules for "
              <> page.1 |> to_string
              <> "@"
              <> other.1 |> to_string,
            )
            True
          }
          Ok(predicate) -> predicate(page.0, other.0)
        }
      })
      |> list.fold(True, bool.and)
    }
  }
}

pub fn part1(updates: Updates, with ruleset: RuleSet) -> Int {
  updates
  |> list.map(fn(update) {
    case check_update(update, ruleset) {
      True -> {
        let assert Ok(mid_index) = int.divide(list.length(update), 2)
        let assert Ok(mid) = list.key_find(update, mid_index)
        mid
      }
      False -> 0
    }
  })
  |> list.fold(0, int.add)
}
