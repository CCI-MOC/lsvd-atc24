.DEFAULT_GOAL := main.pdf

TEXFILES = $(wildcard *.tex)

main.pdf: $(TEXFILES)
	latexmk

clean:
	latexmk -C

