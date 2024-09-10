local:
	mkdir -p tmp
	npx antora --version
	npx antora --stacktrace --log-format=pretty --log-level=warn \
		kw-local-playbook.yml \
		2>&1 | tee tmp/local-build.log 2>&1

remote:
	mkdir -p tmp
	wget 'https://github.com/rancher/product-docs-ui/blob/main/build/ui-bundle.zip?raw=true' -O tmp/ui-bundle.zip
	unzip -o tmp/ui-bundle.zip -d tmp/sp
	npm install && npm update
	npx antora --version
	npx antora --stacktrace --log-format=pretty \
		kw-remote-playbook.yml \
		2>&1 | tee tmp/netlify-build.log 2>&1

clean:
	rm -rf build

environment:
	npm install && npm update
