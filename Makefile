.DEFAULT_GOAL := main.pdf

build/main.pdf: *.tex *.bib
	latexmk

main.pdf: build/main.pdf
	cp $< $@

clean:
	latexmk -C
	rm -f main.pdf

