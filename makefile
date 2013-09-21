CONTRIBUTION = menukeys
SUMMARY = A package to format menus paths and shortcuts.
NAME = Tobias Weh
EMAIL = mail@tweh.de
DIRECTORY = /macros/latex/contrib/${CONTRIBUTION}
LICENSE = free
FREEVERSION = lppl
FILE = ${CONTRIBUTION}.tar.gz

export CONTRIBUTION NAME EMAIL SUMMARY DIRECTORY LICENSE FREEVERSION FILE

ctanify: ${FILE}

${CONTRIBUTION}.pdf:
	mv ${CONTRIBUTION}-doc.pdf ${CONTRIBUTION}.pdf

${CONTRIBUTION}.sty: ${CONTRIBUTION}.ins ${CONTRIBUTION}.dtx
	yes | tex $<
	
${FILE}: ${CONTRIBUTION}.dtx ${CONTRIBUTION}.ins ${CONTRIBUTION}.sty README ${CONTRIBUTION}.pdf
	ctanify $^

upload: ctanify
	ctanupload -p