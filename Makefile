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
remote: tmpdir environment get_and_expand_ui_bundle
	bin/switch-prod-comm product | tee tmp/remote-build.log
	npx antora --version | tee -a tmp/remote-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-remote-playbook.yml 2>&1 | tee -a tmp/remote-build.log

.PHONY: remote-community
remote-community: tmpdir environment get_and_expand_ui_bundle
	bin/switch-prod-comm community | tee tmp/remote-community-build.log
	npx antora --version | tee -a tmp/remote-community-build.log
	npx antora --fetch --stacktrace --log-format=pretty --log-level=info \
		kw-remote-community-playbook.yml \
		2>&1 | tee -a tmp/remote-community-build.log
	bin/switch-prod-comm product | tee -a tmp/remote-community-build.log

.PHONY: clean
clean:
	rm -rf build*
	rm -rf tmp/*.log

.PHONY: environment
environment:
	npm ci || npm install

.PHONY: tmpdir
tmpdir:
	mkdir -p tmp

.PHONY: get_and_expand_ui_bundle
get_and_expand_ui_bundle:
	wget \
		'https://github.com/rancher/product-docs-ui/blob/main/build/ui-bundle.zip?raw=true' \
		-O tmp/ui-bundle.zip \
		&& \
		unzip -o tmp/ui-bundle.zip -d tmp/sp

.PHONY: checkmake
checkmake:
	@if [ $$(which checkmake 2>/dev/null) ]; then \
		checkmake Makefile; \
	else \
		echo "checkmake not available"; \
	fi

.PHONY: preview
preview:
	npx http-server build-rancher-dsc-local/site -c-1