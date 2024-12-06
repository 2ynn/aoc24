import gleam/dict.{type Dict}

pub type Index =
  Int

pub type PageNumber =
  Int

pub type Page =
  #(Index, PageNumber)

pub type Pages =
  List(Page)

pub type Predicate =
  fn(Index, Index) -> Bool

pub type Rules =
  Dict(PageNumber, Predicate)

pub type RuleSet =
  Dict(PageNumber, Rules)

pub type Update =
  List(Page)

pub type Updates =
  List(Update)
