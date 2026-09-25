# capitulos/ — fuente del documento (Markdown)

El cuerpo de la guía vive aquí, **un fichero por sección**, en Markdown. El build
(`generar-pdf.sh`) los concatena **en orden alfabético de nombre de fichero**, antepone
los metadatos de `../metadata.yml` y genera el PDF/DOCX con bibliografía APA.

## Convenciones

- **Orden**: prefijo numérico de dos dígitos (`00-`, `01-`, …). El número del prefijo
  ordena los ficheros; el número visible del título (`# 1. …`) es el del documento.
- **Niveles de encabezado**: `#` = sección de primer nivel (p. ej. `# 1. Introducción…`),
  `##` = subsección (`## 5.1 …`), etc. La numeración se escribe **a mano** en el título
  (no se usa `--number-sections`) para reproducir la numeración del original.
- **Citas**: `[@clave]` usando las claves de `../references.bib` (p. ej. `[@aepd2022]`).
  La sección «Bibliografía» se genera automáticamente con citeproc en
  `07-bibliografia.md` (no se escribe a mano).
- **Figuras/iconos**: rutas relativas a la raíz del repo, p. ej.
  `![Pie de figura](assets/imagenes/IMAG_1.png)`. Los assets están versionados en `assets/`.
- **Recuadros** (reproducen los del original): `::: {.nota}` … `:::` para cajas destacadas
  (relleno lavanda) y `::: {.definicion}` … `:::` para apartados/definiciones (barra azul).
  Se renderizan como `tcolorbox` en el PDF (filtro `pandoc/callouts.lua`); en DOCX el contenido
  se conserva como texto normal.
- **Estado de ingesta**: cada stub abre con un comentario `<!-- INGESTA: … -->` que indica
  el rango de páginas del PDF original (`GUIA_MAQUETADA/29052025_…pdf`) del que procede el
  contenido y si está pendiente. Borra el comentario cuando la sección esté ingerida y revisada.

## Mapa de secciones (← PDF publicado v1.0, Canarias feb. 2024)

| Fichero | Sección | Páginas PDF orig. |
|---|---|---|
| `00-creditos.md` | Créditos / colofón | i (cubierta) |
| `01-introduccion-justificacion.md` | 1. Introducción y justificación | 1–3 |
| `02-que-es-la-ia.md` | 2. ¿Qué es la IA? | 4–6 |
| `03-tipos-de-ia.md` | 3. ¿Qué tipos de IA existen? | 7–12 |
| `04-uso-seguro-etico.md` | 4. Consideraciones para el uso seguro, ético, inclusivo y responsable | 13–16 |
| `05-como-mejora-la-educacion.md` | 5. ¿Cómo puede mejorar la IA la educación? (5.1–5.3) | 17–27 |
| `06-recomendaciones-implementacion.md` | 6. Recomendaciones para la implementación | 28–30 |
| `07-bibliografia.md` | 7. Bibliografía (auto, citeproc) | 31–35 |
| `08-anexo-i-lista-cotejo.md` | 8. Anexo I. Lista de cotejo | 36+ |
