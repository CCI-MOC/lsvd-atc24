.DEFAULT_GOAL := main.pdf

TEXFILES = $(wildcard *.tex)

build/main.pdf: $(TEXFILES)
	latexmk

main.pdf: build/main.pdf
	cp $< $@

clean:
	latexmk -C
	rm -f main.pdf

