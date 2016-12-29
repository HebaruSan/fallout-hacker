TARGETS:=index.html fallout-hacker.css fallout-hacker.js

all: $(TARGETS)

clean:
	rm $(TARGETS)

%.html: %.pug
	jadejs < $< > $@

%.css: %.styl
	stylus -c -m $<

%.js: %.coffee
	coffee -c -b -m  $<
