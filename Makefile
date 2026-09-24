.PHONY: dev build check clean

dev:
	@PORT=1313; \
	while lsof -ti tcp:$$PORT >/dev/null 2>&1; do PORT=$$((PORT + 1)); done; \
	echo "-> starting on http://localhost:$$PORT"; \
	hugo server --buildDrafts --port $$PORT --openBrowser

# --panicOnWarning turns every Hugo warning into a build failure. Deprecated
# APIs warn before they are removed, so this is what stops a deprecation from
# ever reaching main again. Do not remove it to make a build pass.
build:
	hugo --gc --minify --panicOnWarning

check:
	@hugo --gc --minify --panicOnWarning --destination /tmp/hugo-check-$$(basename $$PWD) >/dev/null \
	  && echo "OK   $$(basename $$PWD)" \
	  || { echo "FAIL $$(basename $$PWD)"; exit 1; }

clean:
	rm -rf public resources/_gen .hugo_build.lock
