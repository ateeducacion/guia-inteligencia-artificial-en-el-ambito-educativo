# Ingesta desde el original

Ábrelo al transcribir una sección que todavía lleva el comentario `<!-- INGESTA: … PENDIENTE -->`.

El original maquetado está fuera del repo, en la copia local del autor. Si hace falta traer algo, va a `_origen/` y no se versiona.

De mejor a peor calidad de texto:

- `.cdr` con `cdr2text`: títulos limpios, sin ligaduras, orden de lectura correcto. No da encabezados, listas, tablas ni imágenes. Requiere `brew install libcdr`.
- `.docx` con pandoc: cuerpo, niveles de encabezado y las imágenes. Los títulos decorativos salen rotos.
- PDF: la capa de texto de las fuentes decorativas está rota. Sirve para ver la maqueta, no para copiar texto.

```bash
bash scripts/ingerir.sh [ruta.cdr] [ruta.docx]
```

Deja en `_origen/ingesta/` el texto del CDR, el Markdown del DOCX y `media/`.

Sección a sección:

1. Trabaja sobre `_origen/ingesta/guia-texto.txt`.
2. Localiza la sección con el mapa de [`capitulos/README.md`](../../capitulos/README.md) y transcribe al `.md` del capítulo: encabezados con el título canónico, listas, tablas, énfasis y citas textuales en blockquote. Para tablas y listas, contrasta con `guia-docx.md`.
3. Las imágenes relevantes ya están en `assets/`. Si falta una, está en `_origen/ingesta/media/`.
4. Pasa las referencias autor-fecha a `[@clave]` de `references.bib`.
5. Borra el comentario `<!-- INGESTA: … -->` cuando la sección esté revisada.
6. `make pdf`.

Para recortar una figura nueva del `.cdr`: `soffice --headless --convert-to pdf` y luego `pdftoppm` sobre la página. Úsala como referencia de un TikZ o como PNG.
