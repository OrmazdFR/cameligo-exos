LIGO_VERSION=0.72.0
LIGO=docker run -v $(PWD):$(PWD) -w $(PWD) --rm ligolang/ligo:$(LIGO_VERSION)

#####################

help:
	@echo "C'est la section d'aide"

#####################

ligo-compile:
	@echo "Compiling Tezos contract..."
	@$(LIGO) compile contract contracts/main.mligo --output-file compile/main.tz
	@$(LIGO) compile contract contracts/main.mligo --michelson-format json --output-file compile/main.json

#####################
