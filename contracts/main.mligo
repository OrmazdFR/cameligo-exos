type storage = int

type parameter =
  Increment of int
| Decrement of int
| Reset

type return = operation list * storage

// Two entrypoints
let add (store : storage) (delta : int) : storage =
  store + delta
let sub (store : storage)(delta : int) : storage = 
(store - delta)
let reset (_store : storage) : storage = 0

(* Main access point that dispatches to the entrypoints according to
   the smart contract parameter. *)

let main (action, store : parameter * storage) : return =
  let _x : int = 0 in
  let new_store : storage = match action with
      Increment (n) -> add store n
    | Decrement (n) -> sub store n
    | Reset         -> reset store
  in
  ([] : operation list), new_store