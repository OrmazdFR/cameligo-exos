#import "./helpers/bootstrap.mligo" "Bootstrap"

let () = Test.log("[LOTTERY] Testing entrypoints for contract")

let test_success_submitnumber = 
	let (_admin, user1, _user2) = Bootstrap.bootstrap_accounts() in 
	let (_addr, _t_addr, contr) = Bootstrap.originate_contract(user1) in
	Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez

let test_failure_submitnumber_duplicatenumber = 
	let (_admin, user1, _user2) = Bootstrap.bootstrap_accounts() in 
	let (_addr, _t_addr, contr) = Bootstrap.originate_contract(user1) in
	let _ = Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez in
	let test_result : test_exec_result = Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez in
	let () = Test.log(test_result) in
	let () = match test_result with
		| Fail (Rejected (actual,_)) -> assert (actual = (Test.eval "Number already picked"))

		| Fail (Balance_too_low _err) -> Test.failwith ("Balance is too low")
		| Fail _ -> Test.failwith ("contract failed for an unknown reason")
		| Success (_) -> Test.failwith("Test should have failed")
	in
()

let test_failure_submitnumber_admincannotplay = 
	let (admin, _user1, _user2) = Bootstrap.bootstrap_accounts() in 
	let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
	let () = Test.set_source admin in
	let test_result : test_exec_result = Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez in
	let () = match test_result with
		| Fail (Rejected (actual,_)) -> assert (actual = (Test.eval "Admin cannot submit number"))

		| Fail (Balance_too_low _err) -> Test.failwith ("Balance is too low")
		| Fail _ -> Test.failwith ("contract failed for an unknown reason")
		| Success (_) -> Test.failwith("Test should have failed")
	in
()