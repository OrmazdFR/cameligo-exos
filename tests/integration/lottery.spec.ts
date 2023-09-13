import * as dotenv from 'dotenv';
dotenv.config(({ path: '../../.env' }));

import "mocha";
import * as assert from "assert";

describe("Main", () => {
	let x = "";

	before(async () => {

	});

	it("should be able to run tests", async () => {
		assert.equal(x, "");
	})

	after(async () => {

	})
})