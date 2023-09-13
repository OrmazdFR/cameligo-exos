import { InMemorySigner } from "@taquito/signer";
import { TezosToolkit } from "@taquito/taquito";

import * as dotenv from 'dotenv';
dotenv.config(({ path: '../.env' }));

const TezosNodeRPC: string = process.env.TEZOS_NODE_URL
const publicKey: string = process.env.ADMIN_PUBLIC_KEY;
const privateKey: string = process.env.ADMIN_PRIVATE_KEY;

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider(({ signer: signature }));

Tezos.tz.getBalance(publicKey)
	.then((balance) => console.log(`contractAddressss Balance : ${balance.toNumber() / 1000000} tz`))
	.catch((error) => console.log(JSON.stringify(error)));

	
	const call_submitNumber = async () => {
		try {
		const contractAddress = "KT1FbqocUik4Ur7Cy2PahD9dbaS3dUHhdpRN";

		const instance = await Tezos.contract.at(contractAddress);
		const methods = await instance.methods;
		
		const operation = await instance.methodsObject.submitNumber(1).send();
		const current_storage = await instance.storage();
		console.log(operation);


		// Tezos.contract.at(contractAddress)
		// 	.then((contract) => {
		// 	return contract.methods.submitNumber(50).send();
		// })
		// 	.then((op) => {
		// 		return op.confirmation(3).then(() => op.hash);

		// 	})
		// 	.then((hash) => console.log(`Operation injected: https://ghost.tzstats.com/${hash}`))
		// 	.catch((error) => console.log(`Error: ${JSON.stringify(error, null, 2)}`));


	} catch (error) {
		console.log(error);
	}
}

call_submitNumber();