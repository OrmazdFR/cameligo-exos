#import "../../../contracts/lottery.mligo" "Lottery"

type originated =
  (
   address *
   (Lottery.Parameter.t, Lottery.Storage.t) typed_address *
   Lottery.Parameter.t contract
  )

let bootstrap_accounts () =
  let () = Test.reset_state 5n ([] : tez list) in
  let accounts =
    Test.nth_bootstrap_account 1,
    Test.nth_bootstrap_account 2,
    Test.nth_bootstrap_account 3
  in
  accounts

let initial_storage(initial_admin : address) =
  {
   admin = initial_admin;
   winner = (None : address option);
   numbers = (Map.empty : Lottery.Storage.Types.numbers);
  }

let initial_balance = 0mutez

let originate_contract (admin : address) : originated =
  let init_storage = (Test.eval (initial_storage(admin))) in
  // let (typed_address, _code, _nonce) = Test.originate Lottery.main (initial_storage(admin)) initial_balance in
  let (addr, _code, _nonce) = 
    Test.originate_from_file "../../../contracts/lottery.mligo" "main" (["check_winner"] : string list) (Test.eval (initial_storage(admin))) initial_balance in
  
  let current_storage = Test.get_storage_of_address addr in
  let () = assert (init_storage = current_storage) in
  
  let t_address = Test.cast_address addr in
  let contr = Test.to_contract t_address in

  let addr = Tezos.address contr in
  (addr, t_address, contr)