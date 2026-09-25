---
name: compilacion-pdf
description: Generar el PDF o el DOCX de la guía. Úsalo cuando haya que compilar, cuando make pdf falle, o al tocar generar-pdf.sh o los filtros pandoc.
license: CC-BY-NC-SA-4.0
metadata:
  idioma: es
  tipo: build
  version: "1.0"
  actualizado: 2026-09-25
---

# Compilación

El detalle está en [../../references/compilacion.md](../../references/compilacion.md).

`make pdf` genera los dos temas, lectura e impresión, más el DOCX. Los artefactos de `pdf/` y `docx/` no se versionan. Una versión etiquetada no lleva la marca de agua «BORRADOR».
