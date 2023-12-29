.DEFAULT_GOAL := main.pdf

main.pdf: build/main.pdf
	cp $< $@

TEXFILES = $(wildcard *.tex)

build/main.pdf: $(TEXFILES)
	mkdir -p build
	latexmk

clean:
	latexmk -C

