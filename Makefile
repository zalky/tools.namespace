.PHONY: version tag push-tag jar install deploy test nuke clean

version-number  = 1.3.1
group-id        = io.zalky
artifact-id     = tools.namespace
description     = Fix TNS-6
license         = epl-1

git-sha         = `git rev-parse --short HEAD`
version         = $(version-number)-TNS-6

project-config  = :lib $(group-id)/$(artifact-id) :version "\"$(version)\""
pom-config      = :description "\"$(description)\"" :license :$(license)

version:
	@echo "$(group-id)/$(artifact-id)-$(version)"

tag:
	@git tag $(version)
	@echo "Created tag $(version)"

push-tag:
	@git push origin $(version)

jar: clean
	clojure -T:build jar $(project-config) $(pom-config) :src-dirs '["src/main/clojure"]'

target/$(artifact-id)-$(version).jar:
	@$(MAKE) jar

install: target/$(artifact-id)-$(version).jar
	clojure -T:build install $(project-config)

deploy: target/$(artifact-id)-$(version).jar
	clojure -T:build deploy $(project-config)
	@mv *.pom.asc target/

test:
	clojure -M:test

nuke: clean
	@echo "Nuking everything"
	@rm -rf .cpcache

clean:
	@echo "Cleaning target and resources"
	@rm -rf target
	@rm -rf resources
