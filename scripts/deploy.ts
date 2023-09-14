import { outputFile } from 'fs-extra'
import {char2Bytes } from "@taquito/utils"
import { InMemorySigner } from "@taquito/signer";
import { MichelsonMap, TezosToolkit } from "@taquito/taquito";

import code from "../compile/lottery.json"
import metadataJson from "./metadata.json"
import * as dotenv from 'dotenv';
dotenv.config(( { path: '.env' } ));

const TezosNodeRPC : string = process.env.TEZOS_NODE_URL
const publicKey: string = process.env.ADMIN_PUBLIC_KEY;
const privateKey: string = process.env.ADMIN_PRIVATE_KEY;

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider(( { signer : signature } ));

Tezos.tz.getBalance(publicKey)
	.then((balance) => console.log(`Address Balance : ${balance.toNumber() / 1000000} tz`))
	.catch((error) => console.log(JSON.stringify(error)));

// importKey(Tezos, privateKey)

const saveContractAddress = (name: string, address: string) => {
	outputFile(`scripts/deployments/${name}.ts`,
	`export default "${address}"`)
}

const deploy = async () => {
	try {
		// les const de storage viennent de lottery.mligo
		const storage = {
			admin: publicKey, // vu qu'on veut que ça soit nous et qu'on l'a défini dans le .env
			winner: null, // il n'y a pas de winner quand on initialise le contrat
			numbers: new MichelsonMap(), // on a défini un type numbers = (nat, address) map. **map**, du coup : https://tezostaquito.io/docs/michelsonmap/
			metadata: MichelsonMap.fromLiteral({
				"" : char2Bytes("tezos-storage:jsonFile"),
				"jsonFile": char2Bytes(JSON.stringify(metadataJson))
			}),
		}

		const origination = await Tezos.contract.originate({
			code: code, // importé ligne 7
			storage: storage
		})
		console.log(origination.contractAddress);

		saveContractAddress("deployed_contract", origination.contractAddress);
	} catch (error) {
		console.log(error);
	}
}

deploy();