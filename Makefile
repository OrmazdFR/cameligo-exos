LIGO_VERSION=0.72.0
LIGO=docker run -v $(PWD):$(PWD) -w $(PWD) --rm ligolang/ligo:$(LIGO_VERSION)

#####################

help:
	@echo "C'est la section d'aide"

#####################

ligo-compile:
	@echo "Compiling Tezos contract..."
	@$(LIGO) compile contract contracts/lottery.mligo --output-file compile/lottery.tz
	@$(LIGO) compile contract contracts/lottery.mligo --michelson-format json --output-file compile/lottery.json

#####################

ligo-test:
	@echo "Running tests on Tezos Contract"
	@$(LIGO) run test ./tests/ligo/lottery.test.mligo

#####################

run-deploy:
	@npm run deploy

run-test-submitNumber:
	@npm run call_submitNumber


#####################

all: install ligo-compile ligo-test run-deploy
	@echo "Compiling, testing and deploy code"


#####################

install:
	@npm --prefix ./scripts install

sandbox-start:
	@sh ./scripts/sandbox_start

sandbox-stop:
	@docker stop flextesa-sandbox

sandbox-exec:
	# @docker exec flextesa-sandbox octez-client gen keys mike
	@docker exec flextesa-sandbox octez-client list known addresses
	@docker exec flextesa-sandbox octez-client get balance for alice
	@docker exec flextesa-sandbox octez-client get balance for bob
	@docker exec flextesa-sandbox cat /root/.tezos-client/public_keys
	@docker exec flextesa-sandbox cat /root/.tezos-client/secret_keys