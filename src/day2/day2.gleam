import day2/parse.{parse_file}
import gleam/bool
import gleam/int
import gleam/io
import gleam/list

pub fn run() {
  let reports = parse_file("data/day2/input.txt")

  let safe = part1(reports)
  io.debug("Number of safe reports: " <> { safe |> int.to_string })

  let tolerable = part2(reports)
  io.debug("Additional tolerable reports: " <> { tolerable |> int.to_string })

  io.debug("Total tolerable reports: " <> { safe + tolerable |> int.to_string })
}

pub fn part1(reports: List(List(Int))) -> Int {
  reports |> list.filter(is_report_safe) |> list.length
}

fn is_report_safe(report: List(Int)) -> Bool {
  use <- bool.guard(report == [], False)

  let gradients = list.window_by_2(report) |> list.map(fn(t) { t.1 - t.0 })
  let sign = case gradients |> list.first {
    Ok(first) -> first / int.absolute_value(first)
    Error(_) -> panic as { "Disco" }
  }

  use <- bool.guard(list.any(gradients, is_gradient_unsafe(_, sign)), False)
  True
}

fn is_gradient_unsafe(gradient: Int, sign: Int) -> Bool {
  use <- bool.guard(gradient * sign < 0, True)

  let abs_grad = int.absolute_value(gradient)
  bool.or(0 == abs_grad, abs_grad > 3)
}

fn is_tolerable(unsafe_report: List(Int)) -> Bool {
  let size = unsafe_report |> list.length
  use <- bool.guard(size <= 1, False)

  let combinations = unsafe_report |> list.combinations(size - 1)
  use <- bool.guard(list.any(combinations, is_report_safe), True)
  False
}

pub fn part2(reports: List(List(Int))) -> Int {
  let is_report_unsafe = fn(r) { r |> is_report_safe |> bool.negate }
  let unsafe_reports = list.filter(reports, is_report_unsafe)

  list.filter(unsafe_reports, is_tolerable) |> list.length
}
