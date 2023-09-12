#import "./helpers/bootstrap.mligo" "Bootstrap"

let () = Test.log("[LOTTERY] Testing entrypoints for contract")

let test_success_submitnumber = 
	let (_addr, _t_addr, contr) = Bootstrap.originate_contract() in
	Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez

let test_failure_submitnumber_duplicatenumber = 
	let (_addr, _t_addr, contr) = Bootstrap.originate_contract() in
	let _ = Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez in
	Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez