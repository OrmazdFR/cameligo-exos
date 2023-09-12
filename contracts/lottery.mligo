type numbers = (nat, address) map

type storage =
  {
   admin : address;
   winner : address option;
   numbers : numbers
  }

type parameter =
| SubmitNumber of nat
| CheckWinner of nat

type return = operation list * storage

let submit_number (n : nat) (store : storage) : storage =
  let () =
    if (Tezos.get_sender () = store.admin)
    then (failwith "Admin cannot submit number") in
  let () =
    if (n < 1n) || (n > 100n)
    then (failwith "Number must be between 1 and 100") in
  let map_opt : address option = Map.find_opt n store.numbers in
  match map_opt with
    Some (_) -> failwith "Number already picked"
  | None ->
      let new_numbers = Map.add n (Tezos.get_sender ()) store.numbers in
      {store with numbers = new_numbers}

let check_winner (n : nat) (store : storage) : storage =
  let () =
    if (store.admin <> Tezos.get_sender ())
    then (failwith "Only admin can check winner") in
  let map_opt : address option = Map.find_opt n store.numbers in
  match map_opt with
    None -> failwith "Number not picked"
  | Some (n) -> {store with winner = Some (n)}

let main (action : parameter) (store : storage) : return =
  ([] : operation list),
  (match action with
     SubmitNumber (n) -> submit_number n store
   | CheckWinner (n) -> check_winner n store)
