# variables
## package base name
CONTRIBUTION = menukeys
## package list
PACKAGE = ${CONTRIBUTION}.sty
## final ZIP file name
ZIP = ${CONTRIBUTION}.zip
## cleanup command
CLEANUP = find -E . -type f -regex "\./${CONTRIBUTION}(.?|-doc)\.(aux|glo|gls|hd|idx|ilg|ind|lof|log|lot|out|pdf|toc)" -delete

# generate ZIP
${ZIP}: ${CONTRIBUTION}.dtx ${CONTRIBUTION}.ins README ${CONTRIBUTION}.pdf
	# ZIP
	mkdir ${CONTRIBUTION}
	cp ${CONTRIBUTION}.dtx ${CONTRIBUTION}.ins ${CONTRIBUTION}.pdf README ${CONTRIBUTION}
	zip ${CONTRIBUTION}.zip ./${CONTRIBUTION}/*
	# tidy up
	- $(CLEANUP)
	rm ${CONTRIBUTION}.sty
	rm -r ${CONTRIBUTION}
	
# generate *.sty files
%.sty: ${CONTRIBUTION}.ins ${CONTRIBUTION}.dtx
	latex $<

# generate documentation file
${CONTRIBUTION}.pdf: ${CONTRIBUTION}.dtx ${CONTRIBUTION}.sty
	# tidy up
	- $(CLEANUP)
	# generate doc
	pdflatex ${CONTRIBUTION}.dtx 
	pdflatex ${CONTRIBUTION}.dtx
	makeindex -s gglo.ist -o ${CONTRIBUTION}.gls ${CONTRIBUTION}.glo
	makeindex -s l3doc.ist -o ${CONTRIBUTION}.ind ${CONTRIBUTION}.idx
	pdflatex ${CONTRIBUTION}.dtx
	pdflatex ${CONTRIBUTION}.dtx

clean:
	# tidy up
	- $(CLEANUP)
