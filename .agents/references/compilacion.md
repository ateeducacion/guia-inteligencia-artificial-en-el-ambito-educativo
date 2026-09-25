# Compilación

Ábrelo al generar el PDF o el DOCX, o cuando `make pdf` falle.

```bash
make pdf      # DOCX + dos PDF (lectura e impresión)
make docx     # solo DOCX
make clean    # borra pdf/ y docx/
bash generar-pdf.sh lectura     # o: impresion
```

El mismo `capitulos/` produce dos temas. `lectura` es sobrio. `impresion` replica el original: portadilla de sección a página completa con la fuente display. El preámbulo común va en un heredoc de `generar-pdf.sh`. Lo que cambia por tema es el formato de `\section`, en `gen_header()`.

La marca de agua «BORRADOR» (`draftwatermark`) va en los builds de desarrollo y en la pre-release `preview`. No va en un release con tag. Se quita con `WATERMARK= make pdf`. Se cambia con `WATERMARK="texto"`.

`generar-pdf.sh` ensambla `capitulos/[0-9]*.md` y `metadata.yml`, aplica el preámbulo LaTeX, las tablas zebra (`pandoc/zebra-tables.lua`) y la bibliografía APA (`apa.csl` + `references.bib`). Tectonic descarga solo los paquetes que usa. Si no hay tectonic, el fallback es LibreOffice, sin el estilo LaTeX.

Requisitos: `brew install pandoc tectonic`. El CI fija las versiones en `.github/workflows/preview-pdfs.yml`.

Las fotos se reescalan a unos 300 dpi y pasan a JPEG en una caché temporal (`pandoc/optimize-images.lua`). Los PNG de `assets/` no se modifican. Hace falta ImageMagick o `sips`. Si no hay ninguno, el PDF usa los PNG originales.
