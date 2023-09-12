#import "../../../contracts/lottery.mligo" "Lottery"
type originated =
  {
   addr : address;
   t_addr : (Lottery.parameter, Lottery.storage) typed_address;
   contr : Lottery.parameter contract
  }

let initial_storage =
  {
   admin = ("tz1QXze5AUqG4BCYQYTH5EeydbcnRcgEyJcx" : address);
   winner = (None : address option);
   numbers = (Map.empty : Lottery.numbers);
  }

let initial_balance = 0mutez

let originate_contract() =
  let (typed_address, _code, _nonce) = Test.originate Lottery.main initial_storage initial_balance in
  let actual_storage = Test.get_storage typed_address in
  let () = assert (actual_storage = initial_storage) in
  let contr = Test.to_contract typed_address in
  let addr = Tezos.address contr in
  (addr, typed_address, contr)