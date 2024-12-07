import day6/parse.{parse_map}
import day6/types.{
  type Guard, type Map, type Direction, type Position, type Trail,
  Guard, Up, Down, Left, Right, Empty, Start, Block
}
import gleam/yielder.{type Step, type Yielder}
import gleam/dict
import gleam/int.{to_string}
import gleam/option.{Some, None}
import gleam/io
import gleam/list


pub fn run() {
  let map = parse_map("data/day6/input.txt")

  io.debug("Total path length (part1): " <> { part1(map) |> to_string })
}

// PART 1
pub fn part1(map: Map) -> Int {
  let start_guard = start(map)
  let y = yielder.unfold(from: start_guard, with: continue(on: map, with: _))
  // debug_path(y)

  let trail = y
  |> yielder.group(by: trail_key)
  |> dict.upsert(trail_key(start_guard.pos), fn(pos_list_maybe) {
    case pos_list_maybe {
      Some(pos_list) -> list.prepend(pos_list, start_guard.pos)
      None -> [start_guard.pos]
      }
    })
  // debug_intersections(trail)

  dict.size(trail)
}

fn debug_path(y: Yielder(Position)) {
  io.debug("")
  io.debug("____PATH____")
  y |> yielder.to_list
  |> list.each(fn(pos) { io.debug(trail_key(pos)) })
}

fn debug_intersections(trail: Trail) {
  io.debug("")
  io.debug("_INTERSECTIONS_")
  trail |> dict.each(fn(key, steps) {
      case list.length(steps) {
        1 -> ""
        n -> io.debug(key <> " (" <> n |> to_string <> ")")
      }
    })
}

fn trail_key(pos: Position) -> String {
  pos.0 |> to_string <> "." <> pos.1 |> to_string
}

fn turn(from direction: Direction) -> Direction {
  case direction {
      Up -> Right
      Right -> Down
      Down -> Left
      Left -> Up
    }
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
    Ok(pixel) -> case pixel {
        Empty | Start -> Ok(Guard(..guard, pos: next_pos))
        Block -> move(on: map, with: Guard(..guard, dir: turn(guard.dir)))
    }
  }
}

fn continue(on map: Map, with guard: Guard) -> Step(Position, Guard) {
  case move(on: map, with: guard) {
    Error(_) -> yielder.Done
    Ok(next) -> yielder.Next(next.pos, next)
  }
}

fn start(map: Map) -> Guard {
  let assert Ok(start_tile) =
  map |> dict.to_list |> list.find(fn(pos_pix) { pos_pix.1 == types.Start })

  Guard(pos: start_tile.0, dir: types.Up)
}
