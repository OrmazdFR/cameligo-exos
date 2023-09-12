#import "../../../contracts/lottery.mligo" "Lottery"
type originated =
  {
   addr : address;
   t_addr : (Lottery.parameter, Lottery.storage) typed_address;
   contr : Lottery.parameter contract
  }

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
   numbers = (Map.empty : Lottery.numbers);
  }

let initial_balance = 0mutez

let originate_contract(admin : address) =
  let (typed_address, _code, _nonce) = Test.originate Lottery.main (initial_storage(admin)) initial_balance in
  let current_storage = Test.get_storage typed_address in
  let () = assert (initial_storage(admin) = current_storage) in
  let contr = Test.to_contract typed_address in
  let addr = Tezos.address contr in
  (addr, typed_address, contr)