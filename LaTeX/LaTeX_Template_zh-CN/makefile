tmpfiles = *.aux *.log *.toc *.fls *.nav *.out *.snm *.fdb_latexmk *.vrb *.gz *.xdv

SRC = $(wildcard *.tex)

PDFS = $(SRC:.tex=.pdf)

all:	clean pdf

build:	clean xelatex HW.tex


pdf:	clean $(PDFS)

%.pdf:  %.tex
	xelatex $<

ifeq ($(OS),Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix/Linux
  RM = rm -f
endif

clean:
	$(RM) $(tmpfiles)