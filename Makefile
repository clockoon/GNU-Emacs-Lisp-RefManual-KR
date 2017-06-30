### 

# Copyright (C) 1990-1996, 1998-2017 Free Software Foundation, Inc.

# This file is part of GNU Emacs.

# GNU Emacs is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# GNU Emacs is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

SHELL = /bin/bash

# NB If you add any more configure variables,
# update the sed rules in the dist target below.

# Standard configure variables.
srcdir = .

buildinfodir = .
# Directory with the (customized) texinfo.tex file.
texinfodir = .
# Directory with docstyle.tex and emacsver.texi.
emacsdir = .

prefix = /usr/local
datarootdir = ${prefix}/share
datadir = ${datarootdir}
PACKAGE_TARNAME = emacs
docdir = ${datarootdir}/doc/${PACKAGE_TARNAME}
dvidir = ${docdir}
htmldir = ${docdir}
pdfdir = ${docdir}
psdir = ${docdir}

MKDIR_P = mkdir -p

GZIP_PROG = gzip

HTML_OPTS = --no-split --html

# Options used only when making info output.
INFO_OPTS= --no-split

INSTALL = install -c
INSTALL_DATA = ${INSTALL} -m 644

MAKEINFO = makeinfo
MAKEINFO_OPTS = --force --enable-encoding -I $(emacsdir) -I $(srcdir)
TEXI2DVI = texi2dvi
TEXI2PDF = texi2pdf
DVIPS = dvips

# 'make' verbosity.
AM_DEFAULT_VERBOSITY = 0

AM_V_GEN = $(am__v_GEN_${V})
am__v_GEN_ = $(am__v_GEN_${AM_DEFAULT_VERBOSITY})
am__v_GEN_0 = @echo "  GEN     " $@;
am__v_GEN_1 =

ENVADD = \
  $(AM_V_GEN)TEXINPUTS="$(srcdir):$(texinfodir):$(emacsdir):$(TEXINPUTS)" \
  MAKEINFO="$(MAKEINFO) $(MAKEINFO_OPTS)"

DVI_TARGETS = elisp.dvi
HTML_TARGETS = elisp.html
PDF_TARGETS = elisp.pdf
PS_TARGETS = elisp.ps

# List of all the texinfo files in the manual:

srcs = \
  $(srcdir)/elisp.texi \
  $(emacsdir)/docstyle.texi \
  $(emacsdir)/emacsver.texi \
  $(srcdir)/abbrevs.texi \
  $(srcdir)/anti.texi \
  $(srcdir)/backups.texi \
  $(srcdir)/buffers.texi \
  $(srcdir)/commands.texi \
  $(srcdir)/compile.texi \
  $(srcdir)/control.texi \
  $(srcdir)/customize.texi \
  $(srcdir)/debugging.texi \
  $(srcdir)/display.texi \
  $(srcdir)/edebug.texi \
  $(srcdir)/errors.texi \
  $(srcdir)/eval.texi \
  $(srcdir)/files.texi \
  $(srcdir)/frames.texi \
  $(srcdir)/functions.texi \
  $(srcdir)/hash.texi \
  $(srcdir)/help.texi \
  $(srcdir)/hooks.texi \
  $(srcdir)/internals.texi \
  $(srcdir)/intro.texi \
  $(srcdir)/keymaps.texi \
  $(srcdir)/lists.texi \
  $(srcdir)/loading.texi \
  $(srcdir)/macros.texi \
  $(srcdir)/maps.texi \
  $(srcdir)/markers.texi \
  $(srcdir)/minibuf.texi \
  $(srcdir)/modes.texi \
  $(srcdir)/nonascii.texi \
  $(srcdir)/numbers.texi \
  $(srcdir)/objects.texi \
  $(srcdir)/os.texi \
  $(srcdir)/package.texi \
  $(srcdir)/positions.texi \
  $(srcdir)/processes.texi \
  $(srcdir)/searching.texi \
  $(srcdir)/sequences.texi \
  $(srcdir)/streams.texi \
  $(srcdir)/strings.texi \
  $(srcdir)/symbols.texi \
  $(srcdir)/syntax.texi \
  $(srcdir)/text.texi \
  $(srcdir)/tips.texi \
  $(srcdir)/variables.texi \
  $(srcdir)/windows.texi \
  $(srcdir)/index.texi \
  $(srcdir)/gpl.texi \
  $(srcdir)/doclicense.texi

## Disable implicit rules.
%.texi: ;

.PHONY: info dvi html pdf ps

info: $(buildinfodir)/elisp.info
dvi: $(DVI_TARGETS)
html: $(HTML_TARGETS)
pdf: $(PDF_TARGETS)
ps: $(PS_TARGETS)

${buildinfodir}:
	${MKDIR_P} $@

$(buildinfodir)/elisp.info: $(srcs) | ${buildinfodir}
	$(AM_V_GEN)$(MAKEINFO) $(MAKEINFO_OPTS) $(INFO_OPTS) -o $@ $<

elisp.dvi: $(srcs)
	$(ENVADD) $(TEXI2DVI) $<

elisp.html: $(srcs)
	$(AM_V_GEN)$(MAKEINFO) $(MAKEINFO_OPTS) $(HTML_OPTS) -o $@ $<

elisp.pdf: $(srcs)
	$(ENVADD) $(TEXI2PDF) $<

elisp.ps: elisp.dvi
	$(DVIPS) -o $@ $<

.PHONY: mostlyclean clean distclean bootstrap-clean maintainer-clean infoclean

## [12] stuff is from two-volume.make.
mostlyclean:
	rm -f *.aux *.log *.toc *.cp *.cps *.fn *.fns *.ky *.kys \
	  *.op *.ops *.pg *.pgs *.tp *.tps *.vr *.vrs
	rm -f elisp[12]* vol[12].tmp

clean: mostlyclean infoclean
	rm -f $(DVI_TARGETS) $(HTML_TARGETS) $(PDF_TARGETS) $(PS_TARGETS)
	rm -f vol[12].dvi vol[12].pdf vol[12].ps

distclean: clean
	rm -f Makefile

infoclean:
	rm -f \
	  $(buildinfodir)/elisp.info \
	  $(buildinfodir)/elisp.info-[1-9] \
	  $(buildinfodir)/elisp.info-[1-9][0-9]

bootstrap-clean maintainer-clean: distclean infoclean

.PHONY: install-dvi install-html install-pdf install-ps install-doc

install-dvi: dvi
	umask 022; $(MKDIR_P) "$(DESTDIR)$(dvidir)"
	$(INSTALL_DATA) $(DVI_TARGETS) "$(DESTDIR)$(dvidir)"
install-html: html
	umask 022; $(MKDIR_P) "$(DESTDIR)$(htmldir)"
	$(INSTALL_DATA) $(HTML_TARGETS) "$(DESTDIR)$(htmldir)"
install-pdf: pdf
	 umask 022;$(MKDIR_P) "$(DESTDIR)$(pdfdir)"
	$(INSTALL_DATA) $(PDF_TARGETS) "$(DESTDIR)$(pdfdir)"
install-ps: ps
	umask 022; $(MKDIR_P) "$(DESTDIR)$(psdir)"
	for file in $(PS_TARGETS); do \
	  $(INSTALL_DATA) $${file} "$(DESTDIR)$(psdir)"; \
	  [ -n "${GZIP_PROG}" ] || continue; \
	  rm -f "$(DESTDIR)$(psdir)/$${file}.gz"; \
	  ${GZIP_PROG} -9n "$(DESTDIR)$(psdir)/$${file}"; \
	done

## Top-level Makefile installs the info pages.
install-doc: install-dvi install-html install-pdf install-ps


.PHONY: uninstall-dvi uninstall-html uninstall-pdf uninstall-ps uninstall-doc

uninstall-dvi:
	for file in $(DVI_TARGETS); do \
	  rm -f "$(DESTDIR)$(dvidir)/$${file}"; \
	done
uninstall-html:
	for file in $(HTML_TARGETS); do \
	  rm -f "$(DESTDIR)$(htmldir)/$${file}"; \
	done
uninstall-ps:
	ext= ; [ -n "${GZIP_PROG}" ] && ext=.gz; \
	for file in $(PS_TARGETS); do \
	  rm -f "$(DESTDIR)$(psdir)/$${file}$${ext}"; \
	done
uninstall-pdf:
	for file in $(PDF_TARGETS); do \
	  rm -f "$(DESTDIR)$(pdfdir)/$${file}"; \
	done

uninstall-doc: uninstall-dvi uninstall-html uninstall-pdf uninstall-ps


### Makefile ends here
