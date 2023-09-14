import { InMemorySigner } from "@taquito/signer";
import { TezosToolkit } from "@taquito/taquito";

import networks from "../config";
import accounts from "../accounts";

import contractAddress from "./deployments/deployed_contract"

import * as dotenv from 'dotenv';
dotenv.config(({ path: '.env' }));

const network = process.env.TEZ_NETWORK;
if (network == "mainnet") {
	console.log("about to deploy on mainnet, ctrl+c to abort");
}
const TezosNodeRPC: string = networks[network.toLowerCase()].node_url
console.log(`Tezos Node RPC : ${TezosNodeRPC}`);

const publicKey: string = accounts[network.toLowerCase()].bob.publicKey;
const privateKey: string = accounts[network.toLowerCase()].bob.privateKey;


const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider(({ signer: signature }));

Tezos.tz.getBalance(publicKey)
	.then((balance) => console.log(`contractAddressss Balance : ${balance.toNumber() / 1000000} tz`))
	.catch((error) => console.log(JSON.stringify(error)));
	
const call_submitNumber = async () => {
	try {
		const instance = await Tezos.contract.at(contractAddress);
		const methods = await instance.methods;

		const operation = await instance.methodsObject.submitNumber(1).send();
		const current_storage = await instance.storage();
		console.log(operation);
	} catch (error) {
		console.log(error);
	}
}

call_submitNumber();