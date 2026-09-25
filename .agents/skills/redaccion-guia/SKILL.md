---
name: redaccion-guia
description: Editar un capítulo de la guía, una cita o los metadatos. Úsalo al cambiar capitulos/*.md, metadata.yml o references.bib.
license: CC-BY-NC-SA-4.0
metadata:
  idioma: es
  tipo: redaccion
  version: "1.0"
  actualizado: 2026-09-25
---

# Redacción de la guía

La fuente de verdad es `capitulos/*.md` y `metadata.yml`. No se edita el PDF.

## Al escribir

- Un `.md` por sección, prefijo `00-`, `01-`, … El build los concatena por nombre.
- El número visible (`# 1.`, `## 5.1`) se escribe a mano. No uses `--number-sections`.
- Citas con `[@clave]` de `references.bib`. La bibliografía de `capitulos/07-bibliografia.md` la genera citeproc.
- Imagen: `![Pie](assets/imagenes/IMAG_1.png)`.
- Recuadros: `::: {.nota}` y `::: {.definicion}`.
- Un diagrama va en un bloque `{=latex}` con TikZ. El DOCX no lo incluye.
- La prosa explicativa puede pasar por `lenguaje-claro`. Una cita textual se queda como está.

El mapa de secciones está en [`capitulos/README.md`](../../../capitulos/README.md). Bibliografía y releases: [../../references/bibliografia-y-releases.md](../../references/bibliografia-y-releases.md).

Antes de dar el cambio por bueno, `make pdf` termina sin error.
