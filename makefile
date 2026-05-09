# variables
## package base name
CONTRIBUTION = menukeys
## final ZIP file name
ZIP = ${CONTRIBUTION}.zip
## TeX-engine to use
TEX = pdflatex
## temporary build directory
BUILD = ./build
## files that need to be included in the release
ZIPFILES = ${CONTRIBUTION}.dtx ${CONTRIBUTION}.ins ${CONTRIBUTION}.pdf README
## cleanup command
CLEANUP = -rm -rf ${BUILD}/doc/*
## command for one TeX run in the build folder
TEXRUN = cd ${BUILD}/doc; ${TEX} ${CONTRIBUTION}.dtx
## command to run find with regex
FIND = find . -type f -regextype posix-extended -regex

all: ${ZIP}
doc: ${CONTRIBUTION}.pdf
sty: ${CONTRIBUTION}.sty

# generate ZIP
${ZIP}: ${CONTRIBUTION}.pdf README
	# ZIP
	mkdir ${CONTRIBUTION}
	cp ${ZIPFILES} ${CONTRIBUTION}
	zip ${CONTRIBUTION}.zip ./${CONTRIBUTION}/*
	rm -r ${CONTRIBUTION}

# generate *.sty files
%.sty: ${CONTRIBUTION}.ins ${CONTRIBUTION}.dtx
	mkdir -p ${BUILD}/sty
	cp $^ ${BUILD}/sty
	cd ${BUILD}/sty; latex $<
	cp ${BUILD}/sty/$@ .

# generate documentation file
${CONTRIBUTION}.pdf: ${CONTRIBUTION}.dtx ${CONTRIBUTION}.sty ${CONTRIBUTION}.ist
	# tidy up
	$(CLEANUP)
	mkdir -p ${BUILD}/doc
	cp $^ ${BUILD}/doc
	# generate doc
	${TEXRUN}
	${TEXRUN}
	cd ${BUILD}/doc; makeindex -s gglo.ist -o ${CONTRIBUTION}.gls ${CONTRIBUTION}.glo
	cd ${BUILD}/doc; makeindex -s ${CONTRIBUTION}.ist -o ${CONTRIBUTION}.ind ${CONTRIBUTION}.idx
	${TEXRUN}
	${TEXRUN}
	cp ${BUILD}/doc/$@ .

clean-pdf:
	${FIND} "\./${CONTRIBUTION}(.?|-doc)\.pdf" -delete
clean-sty:
	${FIND} "\./${CONTRIBUTION}(-20.*)?.sty" -delete
clean-zip:
	-rm ${ZIP}
clean: clean-pdf clean-sty clean-zip
	-rm -rf ${BUILD}

.PHONY: clean clean-pdf clean-sty clean-zip all doc sty
