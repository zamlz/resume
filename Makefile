
# __  __       _         __ _ _
#|  \/  | __ _| | _____ / _(_) | ___
#| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
#| |  | | (_| |   <  __/  _| | |  __/
#|_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#

###################################################

PDFEXE    = pdflatex --shell-escape
BIBEXE    = bibtex
PDFTEST   = zathura

CLASS     = cv.cls
MINSRC    = resume.tex
MAXSRC	  = '\providecommand{\fullresume{true}}\input{${MINSRC}}'

BIBSRC    = papers.bib
PUBSEXE   = $${HOME}/.local/bin/pubs
PUBSPAPER = ${PUBSEXE} list -k citekey:amlesh
PUBSEXPORT= xargs ${PUBSEXE} export

MINFILE   = amlesh_resume.pdf
MAXFILE   = amlesh_curriculum_vitae.pdf

MISCFILE  = ${MINSRC:.tex=.aux} \
	    ${MINSRC:.tex=.log} \
	    ${MINSRC:.tex=.dvi} \
	    ${MINSRC:.tex=.out} \
	    ${MINSRC:.tex=.bbl} \
	    ${MINSRC:.tex=.blg} \
	    ${MINSRC:.tex=.toc} \

MAKEARGS  = --no-print-directory -C

####################################################

# Build both versions of the resume and view them.
pdf: ${MINFILE} ${MAXFILE}

# Build instructions for the single page resume
${MINFILE}: ${MINSRC} ${BIBSRC} ${CLASS}
	-${PDFEXE} ${MINSRC}
	-${BIBEXE} ${MINSRC:.tex=.aux}
	-${PDFEXE} ${MINSRC}
	-${PDFEXE} ${MINSRC}
	mv ${MINSRC:.tex=.pdf} ${MINFILE}

# Build instructions for the full resume
${MAXFILE}: ${MINSRC} ${BIBSRC} ${CLASS}
	-${PDFEXE} ${MAXSRC}
	-${BIBEXE} ${MAXSRC:.tex=.aux}
	-${PDFEXE} ${MAXSRC}
	-${PDFEXE} ${MAXSRC}
	mv ${MINSRC:.tex=.pdf} ${MAXFILE}

# Create biblio file of papers you've authored
bib:
	-${PUBSPAPER} | ${PUBSEXPORT} > ${BIBSRC}

# Clean the build directory
clean:
	-rm -fv ${MISCFILE}
	-rm -rfv _minted*/
	-rm -rf .svg/

# clean the directory and move the pdfs into the docs directory
spotless: clean
	-rm ${MINSRC:.tex=.pdf}
	-rm ${MINFILE}
	-rm ${MAXFILE}

# spotless + pdf...
refresh: spotless pdf

# Run spotless, but also check in changes with git
ci: spotless
	git add .
	git commit -e

# Preview the document in real time
preview: spotless pdf
	${PDFTEST} ${MAXFILE} &
	while true; do \
		make PDFEXE="${PDFEXE} -interaction=nonstopmode" pdf > \
		/dev/null; \
		sleep 1; \
	done;
