DEST=root@coffland.com:/var/www/tplang.org/http/
JADE=./node_modules/jade/bin/jade.js
STYLUS=./node_modules/stylus/bin/stylus

SRC=tpl.jade tpl.styl tpl.js
STATIC=$(shell find static/ -type f)

TARGETS:=$(patsubst %.jade,%.html,$(SRC))
TARGETS:=$(patsubst %.styl,%.css,$(TARGETS))
TARGETS:=$(patsubst %,http/%,$(TARGETS))
TARGETS+=$(patsubst static/%,http/%,$(STATIC))

all: node_modules $(TARGETS)

node_modules: package.json
	npm install

http/tpl.html: $(wildcard src/templates/*.jade)

http/%.html: src/%.jade
	@mkdir -p http
	$(JADE) -P $< -o http

http/%.css: src/%.styl
	@mkdir -p http
	$(STYLUS) <$<>$@

http/%.js: src/%.js
	install -D $< $@

http/%: static/%
	install -D $< $@

publish: all
	rsync -av http/* $(DEST)

tidy:
	rm -f $(shell find . -name *~)

clean: tidy
	rm -rf http
