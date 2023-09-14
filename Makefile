LIGO_VERSION=0.72.0
LIGO=docker run -v $(PWD):$(PWD) -w $(PWD) --rm ligolang/ligo:$(LIGO_VERSION)

#####################

help:
	@echo "C'est la section d'aide"

#####################

ligo-compile: lottery
	@echo "Compiling Tezos contract..."
	@$(LIGO) compile contract contracts/$^.mligo --output-file compile/$^.tz
	@$(LIGO) compile contract contracts/$^.mligo --michelson-format json --output-file compile/$^.json

#####################

ligo-test: lottery
	@echo "Running tests on Tezos Contract"
	@$(LIGO) run test ./tests/ligo/$^.test.mligo

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