.PHONY: all test

.PHONY: local
  local: tmpdir environment
	bin/switch-prod-comm product | tee tmp/local-build.log
	npx antora --version | tee -a tmp/local-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-local-playbook.yml 2>&1 | tee -a tmp/local-build.log

.PHONY: rancher-dsc
rancher-dsc: tmpdir environment
	bin/switch-prod-comm product | tee tmp/rancher-dsc-build.log
	npx antora --version | tee -a tmp/rancher-dsc-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-rancher-dsc.yml 2>&1 | tee -a tmp/rancher-dsc-build.log

.PHONY: rancher-dsc-local
rancher-dsc-local: tmpdir environment
	bin/switch-prod-comm product | tee tmp/rancher-dsc-local-build.log
	npx antora --version | tee -a tmp/rancher-dsc-local-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-rancher-dsc-local.yml  2>&1 | tee -a tmp/rancher-dsc-local-build.log

.PHONY: local-community
local-community: tmpdir environment
	bin/switch-prod-comm community | tee tmp/local-community-build.log
	npx antora --version | tee -a tmp/local-community-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-local-community-playbook.yml \
		2>&1 | tee -a tmp/local-community-build.log
	# Now maintain the default product build configuration
	bin/switch-prod-comm product | tee tmp/local-community-build.log

.PHONY: remote
remote: tmpdir environment
	bin/switch-prod-comm product | tee tmp/remote-build.log
	npx antora --version | tee -a tmp/remote-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-remote-playbook.yml 2>&1 | tee -a tmp/remote-build.log

.PHONY: remote-community
remote-community: tmpdir environment
	bin/switch-prod-comm community | tee tmp/remote-community-build.log
	npx antora --version | tee -a tmp/remote-community-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-remote-community-playbook.yml \
		2>&1 | tee -a tmp/remote-community-build.log
	bin/switch-prod-comm product | tee -a tmp/remote-community-build.log

.PHONY: first-local
first-local: tmpdir environment
	bin/switch-prod-comm product | tee tmp/first-local-build.log
	npx antora --version | tee -a tmp/first-local-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-rancher-first-local.yml \
		2>&1 | tee -a tmp/remote-community-build.log
	bin/switch-prod-comm product | tee -a tmp/first-local-build.log

.PHONY: original-local
original-local: tmpdir environment
	bin/switch-prod-comm product | tee tmp/original-local-build.log
	npx antora --version | tee -a tmp/original-local-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-rancher-original-local.yml \
		2>&1 | tee -a tmp/remote-community-build.log
	bin/switch-prod-comm product | tee -a tmp/original-local-build.log

.PHONY: clean
clean:
	rm -rf build*
	rm -rf tmp/*.log

NPM_FLAGS = --no-color --no-progress
.PHONY: environment
environment:
	npm $(NPM_FLAGS) ci || npm $(NPM_FLAGS) install

.PHONY: tmpdir
tmpdir:
	mkdir -p tmp

.PHONY: checkmake
checkmake:
	@if [ $$(which checkmake 2>/dev/null) ]; then checkmake Makefile; \
		if [ $$? -ne 0 ]; then echo "checkmake failed"; exit 1; \
		else echo "checkmake passed"; \
		fi; \
	else echo "checkmake not available"; fi

.PHONY: preview
preview:
	npx http-server build-rancher-dsc-local/site -c-1
