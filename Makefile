local:
	mkdir -p tmp
	npx antora --version
	npx antora --stacktrace --log-format=pretty --log-level=warn \
		kw-local-playbook.yml \
		2>&1 | tee tmp/local-build.log 2>&1

netlify:
	mkdir -p tmp
	npm install && npm update
	npx antora --version
	npx antora --stacktrace --log-format=pretty \
		kw-netlify-playbook.yml \
		2>&1 | tee tmp/netlify-build.log 2>&1

clean:
	rm -rf build

environment:
	npm install && npm update
