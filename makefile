# variables
## package base name
CONTRIBUTION = menukeys
## final ZIP file name
ZIP = ${CONTRIBUTION}.zip
## cleanup command
CLEANUP = find . -type f -regextype posix-extended -regex "\./${CONTRIBUTION}(.?|-doc)\.(aux|glo|gls|hd|idx|ilg|ind|lof|log|lot|out|toc)" -delete
## TeX-engine to use
TEX = /usr/local/texlive/2021/bin/x86_64-linux/pdflatex
## if it doesn't exist fall back to any pdflatex
ifeq ("$(wildcard ${TEX})","")
	TEX = pdflatex
endif
## temporary build directory
BUILD := ${CONTRIBUTION}

all: ${ZIP}

# generate ZIP
${ZIP}: ${CONTRIBUTION}.pdf README
	# ZIP
	mkdir ${CONTRIBUTION}
	cp ${CONTRIBUTION}.dtx ${CONTRIBUTION}.ins ${CONTRIBUTION}.pdf README ${CONTRIBUTION}
	zip ${CONTRIBUTION}.zip ./${CONTRIBUTION}/*
	rm -r ${CONTRIBUTION}

# generate *.sty files
%.sty: ${CONTRIBUTION}.ins ${CONTRIBUTION}.dtx
	latex $<

# generate documentation file
${CONTRIBUTION}.pdf: ${CONTRIBUTION}.dtx ${CONTRIBUTION}.sty
	# tidy up
	$(CLEANUP)
	# generate doc
	${TEX} ${CONTRIBUTION}.dtx
	${TEX} ${CONTRIBUTION}.dtx
	makeindex -s gglo.ist -o ${CONTRIBUTION}.gls ${CONTRIBUTION}.glo
	makeindex -s l3doc.ist -o ${CONTRIBUTION}.ind ${CONTRIBUTION}.idx
	${TEX} ${CONTRIBUTION}.dtx
	${TEX} ${CONTRIBUTION}.dtx

clean-most:
	$(CLEANUP)
clean-pdf:
	find . -type f -regextype posix-extended -regex "\./${CONTRIBUTION}(.?|-doc)\.pdf" -delete
clean-sty:
	-rm ${CONTRIBUTION}.sty ${CONTRIBUTION}-20*.sty
clean-zip:
	-rm ${ZIP}
clean: clean-most clean-pdf clean-sty clean-zip

.PHONY: clean clean-most clean-pdf clean-sty clean-zip all
