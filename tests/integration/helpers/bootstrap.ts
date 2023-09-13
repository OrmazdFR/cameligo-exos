import * as dotenv from 'dotenv';
dotenv.config(({ path: '../.env' }));

import { InMemorySigner } from "@taquito/signer";
import { TezosToolkit } from "@taquito/taquito";


const TezosNodeRPC: string = process.env.TEZOS_NODE_URL
const publicKey: string = process.env.ADMIN_PUBLIC_KEY;
const privateKey: string = process.env.ADMIN_PRIVATE_KEY;

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider(({ signer: signature }));