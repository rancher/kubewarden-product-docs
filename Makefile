local:
	mkdir -p tmp
	npx antora --version
	npx antora --stacktrace --log-format=pretty --log-level=warn \
		kw-local-playbook.yml \
		2>&1 | tee tmp/local-build.log 2>&1

remote:
	mkdir -p tmp
	curl 'https://github.com/rancher/product-docs-ui/blob/main/build/ui-bundle.zip?raw=true' > tmp/ui-bundle.zip
	npm install && npm update
	npx antora --version
	npx antora --stacktrace --log-format=pretty \
		kw-remote-playbook.yml \
		2>&1 | tee tmp/netlify-build.log 2>&1

clean:
	rm -rf build

environment:
	npm install && npm update
