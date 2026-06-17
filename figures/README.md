# figures/ — figuras y diagramas propios de la guía

Diagramas/figuras creados para la guía (no fotografías ni iconos: esos van en `assets/`).
Preferible **vectorial** (`.svg`); el build regenera el `.png` desde el `.svg` si hay
`rsvg-convert`/`inkscape` (si no, usa el `.png` versionado). Referencia desde un capítulo:
`![Pie de figura](figures/mi-diagrama.png)`.
