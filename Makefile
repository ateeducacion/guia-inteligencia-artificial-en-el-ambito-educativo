# Makefile — generar la guía (PDF/DOCX), el índice de fuentes y sumas de verificación.
# Requiere: pandoc + tectonic (PDF). Ver README.md / AGENTS.md.

.PHONY: help pdf docx fuentes sums clean all

help:
	@echo "Objetivos disponibles:"
	@echo "  pdf      - genera PDF + DOCX de la guía (bash generar-pdf.sh) en pdf/ y docx/"
	@echo "  docx     - genera solo el DOCX (rápido, solo pandoc) en docx/"
	@echo "  fuentes  - regenera fuentes/README.md (índice APA) desde references.bib"
	@echo "  sums     - escribe pdf/SHA256SUMS con el SHA-256 del PDF"
	@echo "  clean    - borra los artefactos generados en docx/ y pdf/"
	@echo "  all      - fuentes + pdf + sums"

pdf:
	bash generar-pdf.sh

docx:
	bash generar-pdf.sh docx

fuentes:
	bash scripts/generar-indice-fuentes.sh

sums:
	cd pdf && shasum -a 256 *.pdf > SHA256SUMS

clean:
	rm -f docx/*.docx pdf/*.pdf pdf/SHA256SUMS

all: fuentes pdf sums
