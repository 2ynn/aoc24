import gleam/bool

/// Panics if a given condition is met, otherwise returns False.
pub fn panic_if(when cond: Bool, message msg: String) -> Bool {
  bool.guard(bool.negate(cond), False, fn() { panic as msg })
}
