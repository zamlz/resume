
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

MINSRC    = resume.tex
MAXSRC	  = '\providecommand{\fullresume{true}}\input{${MINSRC}}'
BIBSRC    = bibliography.bib

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
pdf: single-page full
	${PDFTEST} ${MINFILE}
	${PDFTEST} ${MAXFILE}

# Build instructions for the single page resume
single-page: ${MINSRC} ${BIBSRC}
#	-${PDFEXE} ${MINSRC}
#	-${BIBEXE} ${MINSRC:.tex=.aux}
#	-${PDFEXE} ${MINSRC}
	-${PDFEXE} ${MINSRC}
	mv ${MINSRC:.tex=.pdf} ${MINFILE}

# Build instructions for the full resume
full: ${MINSRC} ${BIBSRC}
#	-${PDFEXE} ${MAXSRC}
#	-${BIBEXE} ${MAXSRC:.tex=.aux}
#	-${PDFEXE} ${MAXSRC}
	-${PDFEXE} ${MAXSRC}
	mv ${MINSRC:.tex=.pdf} ${MAXFILE}

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
