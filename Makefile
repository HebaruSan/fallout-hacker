TARGETS:=index.html fallout-hacker.css fallout-hacker.js

all: $(TARGETS)

clean:
	rm $(TARGETS)

%.html: %.pug
	jadejs < $< > $@

%.css: %.styl
	stylus $<

%.js: %.coffee
	coffee -c $<
