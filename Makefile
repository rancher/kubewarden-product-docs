# Don't run makes in parallel, stuff will break

local:
	mkdir -p tmp
	bin/switch-prod-comm product | tee tmp/local-build.log
	npx antora --version | tee -a tmp/local-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-local-playbook.yml \
		2>&1 | tee -a tmp/local-build.log

local-community:
	mkdir -p tmp
	bin/switch-prod-comm community | tee tmp/local-community-build.log
	npx antora --version | tee -a tmp/local-community-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-local-community-playbook.yml \
		2>&1 | tee -a tmp/local-community-build.log
	# Now maintain the default product build configuration
	bin/switch-prod-comm product | tee tmp/local-community-build.log

remote:
	mkdir -p tmp
	wget 'https://github.com/rancher/product-docs-ui/blob/main/build/ui-bundle.zip?raw=true' -O tmp/ui-bundle.zip
	unzip -o tmp/ui-bundle.zip -d tmp/sp
	npm install && npm update
	bin/switch-prod-comm product | tee tmp/remote-build.log
	npx antora --version | tee -a tmp/remote-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-remote-playbook.yml \
		2>&1 | tee -a tmp/remote-build.log

remote-community:
	mkdir -p tmp
	wget 'https://github.com/rancher/product-docs-ui/blob/main/build/ui-bundle.zip?raw=true' -O tmp/ui-bundle.zip
	unzip -o tmp/ui-bundle.zip -d tmp/sp
	npm install && npm update
	bin/switch-prod-comm community | tee tmp/remote-community-build.log
	npx antora --version | tee -a tmp/remote-community-build.log
	npx antora --stacktrace --log-format=pretty --log-level=info \
		kw-remote-community-playbook.yml \
		2>&1 | tee -a tmp/remote-community-build.log
	bin/switch-prod-comm product | tee -a tmp/remote-community-build.log

clean:
	rm -rf build*

environment:
	npm install && npm update
