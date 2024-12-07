import day6/parse.{parse_map}
import day6/types.{
  type Blocker, type Direction, type Guard, type Map, type Path, type Position,
  type Trail, Block, Down, Empty, Guard, Left, Right, Start, Up,
}
import gleam/dict
import gleam/function.{identity}
import gleam/int.{to_string}
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import gleam/yielder.{type Step, type Yielder}

pub fn run() {
  let map = parse_map("data/day6/input.txt")

  let trail = part1(map)
  debug_intersections(trail)

  io.debug("Total coverage (part1): " <> { trail |> dict.size |> to_string })

  let blockers = part2(map)
  set.each(blockers, io.debug)
  io.debug(
    "Number of blockers (part2): " <> { blockers |> set.size |> to_string },
  )
}

// PART 1
pub fn part1(map: Map) -> Trail {
  let start_guard = start(map)
  let y = yielder.unfold(from: start_guard, with: continue1(on: map, with: _))
  debug_path(y)
  get_trail(start_guard, y)
}

fn get_trail(from start_guard: Guard, with y: Yielder(Guard)) -> Trail {
  y
  |> yielder.group(by: trail_key)
  |> dict.upsert(trail_key(start_guard), fn(pos_list_maybe) {
    case pos_list_maybe {
      Some(pos_list) -> list.prepend(pos_list, start_guard)
      None -> [start_guard]
    }
  })
}

fn debug_path(y: Yielder(Guard)) {
  io.debug("")
  io.debug("____PATH____")
  y
  |> yielder.to_list
  |> list.each(fn(g) { io.debug(trail_key(g)) })
}

fn debug_intersections(trail: Trail) {
  io.debug("")
  io.debug("_INTERSECTIONS_")
  trail
  |> dict.each(fn(key, steps) {
    case list.length(steps) {
      1 -> ""
      n -> io.debug(key <> " (" <> n |> to_string <> ")")
    }
  })
}

fn trail_key(guard: Guard) -> String {
  guard.pos.0 |> to_string <> "." <> guard.pos.1 |> to_string
}

fn turn(from direction: Direction) -> Direction {
  case direction {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}

fn start(map: Map) -> Guard {
  let assert Ok(start_tile) =
    map |> dict.to_list |> list.find(fn(pos_pix) { pos_pix.1 == types.Start })

  Guard(pos: start_tile.0, dir: types.Up)
}

fn next_position(guard: Guard) -> Position {
  let offset = case guard.dir {
    Up -> #(-1, 0)
    Down -> #(1, 0)
    Left -> #(0, -1)
    Right -> #(0, 1)
  }

  #(guard.pos.0 + offset.0, guard.pos.1 + offset.1)
}

fn move(on map: Map, with guard: Guard) -> Result(Guard, Nil) {
  let next_pos = next_position(guard)
  case dict.get(map, next_pos) {
    Error(_) -> Error(Nil)
    Ok(pixel) ->
      case pixel {
        Empty | Start -> Ok(Guard(..guard, pos: next_pos))
        Block -> move(on: map, with: Guard(..guard, dir: turn(guard.dir)))
      }
  }
}

fn continue1(on map: Map, with guard: Guard) -> Step(Guard, Guard) {
  case move(on: map, with: guard) {
    Error(_) -> yielder.Done
    Ok(next) -> yielder.Next(next, next)
  }
}

// PART 2
pub fn part2(map) -> Set(Blocker) {
  io.debug("")
  io.debug("__BLOCKERS__")

  let blockers =
    map
    |> dict.to_list
    |> list.filter_map(fn(tile) {
      case tile.1 {
        Block -> Ok(tile.0)
        _ -> Error(Nil)
      }
    })

  let start_guard = start(map)
  yielder.unfold(from: [start_guard], with: continue2(on: map, from: _))
  |> yielder.to_list
  |> list.filter_map(fn(option) {
    case option {
      Some(blocker) -> Ok(blocker)
      None -> Error(Nil)
    }
  })
  |> set.from_list
  |> set.drop(list.prepend(blockers, start_guard.pos))
}

fn continue2(on map: Map, from path: Path) -> Step(Option(Blocker), Path) {
  let assert Ok(guard) = list.last(path)

  case move(on: map, with: guard) {
    Error(_) -> yielder.Done
    Ok(next) -> {
      io.debug(trail_key(next))
      let next_path = list.append(path, [next])
      case move(on: map, with: Guard(..guard, dir: turn(guard.dir))) {
        Ok(test_guard) -> {
          let test_path = list.append(path, [test_guard])
          yielder.Next(check_for_loop(map, next.pos, test_path), next_path)
        }
        Error(_) -> yielder.Next(None, next_path)
      }
    }
  }
}

fn check_for_loop(
  on map: Map,
  with blocker: Blocker,
  seen path: Path,
) -> Option(Blocker) {
  case
    yielder.unfold(from: path, with: continue_check(map, _))
    |> yielder.find(identity)
  {
    Ok(_) -> Some(blocker)
    Error(_) -> None
  }
}

fn continue_check(on map: Map, seen path: Path) -> Step(Bool, Path) {
  case list.last(path) {
    Error(_) -> {
      yielder.Done
    }
    Ok(last) -> {
      case move(on: map, with: last) {
        Error(_) -> yielder.Done
        Ok(next) -> {
          case list.find(path, fn(g) { g == next }) {
            Ok(_) -> {
              io.debug("   !")
              yielder.Next(True, [])
            }
            Error(_) -> {
              yielder.Next(False, list.append(path, [next]))
            }
          }
        }
      }
    }
  }
}
