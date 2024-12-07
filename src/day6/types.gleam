import gleam/dict.{type Dict}

pub type Row =
  Int

pub type Col =
  Int

pub type Position =
  #(Row, Col)

pub type Pixel {
  Empty
  Block
  Start
}

pub type Tile {
  Tile(pos: Position, pix: Pixel)
}

pub type Map =
  Dict(Position, Pixel)

pub type Direction {
  Up
  Down
  Left
  Right
}

pub type Guard {
  Guard(pos: Position, dir: Direction)
}

pub type Trail =
  Dict(String, List(Guard))
