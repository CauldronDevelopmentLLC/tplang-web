TARGETS=tpl.html tpl.css
DEST=root@coffland.com:/var/www/tplang.org/http/
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

JADE=./node_modules/jade/bin/jade.js
STYLUS=./node_modules/stylus/bin/stylus

all: node_modules $(TARGETS)

node_modules: package.json
	npm install

%.html: %.jade
	$(JADE) -P $<

%.css: %.styl
	$(STYLUS) <$<>$@

publish: all
	rsync -av static/* tpl.html tpl.css tpl.js $(DEST)

tidy:
	rm -f *~

clean: tidy
	rm -f $(TARGETS)
