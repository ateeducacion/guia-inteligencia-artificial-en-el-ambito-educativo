# AGENTS.md — Runbook de gestión documental

Cómo mantener y generar la guía *«La inteligencia artificial (IA) en el ámbito educativo»*
en este repositorio. Va dirigido a personas mantenedoras y a agentes de IA que trabajen aquí.

**Idea central:** la guía es un **documento vivo en Markdown** que se compila a un **PDF de
calidad con LaTeX** (`pandoc` + `tectonic`), sustituyendo la maquetación manual en CorelDraw.
Todo lo necesario para reconstruir el PDF está versionado (texto, bibliografía, assets,
estilo); los binarios pesados, las fuentes de terceros y las tipografías de marca, no.

## Reglas rápidas

- **Fuente de verdad del contenido:** `capitulos/*.md` + `metadata.yml`. No se edita el PDF.
- **Fuente de verdad de la bibliografía:** `references.bib` (se edita a mano; **sin** sync con Zotero).
- **No subir binarios con copyright** ni tipografías de marca (ver `.gitignore`).
- **Antes de dar por bueno un cambio, compila:** `make pdf` debe terminar sin error.
- El **original maquetado** (DOCX/PDF/CorelDraw, fuentes, históricos) se mantiene **en local,
  fuera del repo** (copia del autor en `~/Downloads/GUIA_MAQUETADA/`). Si necesitas traer algo
  para trabajar, déjalo en `_origen/` (está `gitignored`).

## Estructura y convenciones

- **Documento:** `capitulos/` con un `.md` por sección, prefijados `00-`, `01-`, … El build los
  concatena por orden de nombre. La numeración visible del título (`# 1. …`, `## 5.1 …`) se
  escribe a mano (no se usa `--number-sections`) para reproducir la del original. Detalle y
  mapa de secciones ↔ páginas del PDF original en [`capitulos/README.md`](capitulos/README.md).
- **Citas:** `[@clave]` con claves de `references.bib`. La lista de referencias la coloca
  citeproc en `capitulos/07-bibliografia.md` (div `#refs`); **no se escribe a mano**.
- **Recursos visuales:** `assets/iconos/`, `assets/imagenes/`, `assets/fondos/` (versionados).
  Referencia por ruta relativa a la raíz: `![Pie](assets/imagenes/IMAG_1.png)`.
- **Tipografías de marca:** en `assets/tipografias/` (no versionadas; ver su README). El
  preámbulo usa `\IfFontExistsTF{…}` y degrada con elegancia si no están.

## Build (PDF/DOCX)

```bash
make pdf      # = bash generar-pdf.sh -> dos PDF (lectura + impresión) + DOCX
make docx     # solo DOCX (rápido)
make clean    # borra pdf/ y docx/
bash generar-pdf.sh lectura     # construir solo un tema (o: impresion)
```

**Dos temas, mismo contenido** (`capitulos/`): el build genera `…-lectura.pdf` (sobrio) y
`…-impresion.pdf` (réplica visual del original). El preámbulo común va en un heredoc; lo que
cambia por tema es el formato de `\section` (lo aplica `gen_header()` en `generar-pdf.sh`):
lectura = encabezado sobrio con filete; impresión = **portadilla** de sección a página completa
con la fuente *display* (Michroma). Para enriquecer la réplica (cubierta, fondos), se amplía
solo el bloque del tema `impresion`.

**Marca de agua «BORRADOR»** (`draftwatermark`): se aplica a los builds de **desarrollo/main**
(incluida la CI → pre-release `preview`) y **no** a un release con tag. Lógica: marca activa
salvo que `HEAD` sea exactamente un tag, o que se fije `WATERMARK` por entorno
(`WATERMARK= make pdf` la quita; `WATERMARK="texto"` la cambia). El PDF original de la `v1.0`
no se genera aquí, así que va sin marca.

`generar-pdf.sh` (cadena pandoc → tectonic):
- Ensambla `capitulos/[0-9]*.md` + `metadata.yml`.
- Aplica el preámbulo LaTeX (portada, índice, secciones sobrias, tablas zebra vía
  `pandoc/zebra-tables.lua`), bibliografía APA (`apa.csl` + `references.bib` vía citeproc).
- **Tectonic** descarga bajo demanda solo los paquetes que use y los cachea (no requiere TeX
  Live completo). Fallback a LibreOffice si no hay tectonic (sin el estilo LaTeX).

Requisitos: `brew install pandoc tectonic`. El CI (`.github/workflows/preview-pdfs.yml`) fija
versiones de pandoc/tectonic para builds reproducibles.

## Flujo de INGESTA (desde la guía original)

**Jerarquía de fuentes** (de mejor a peor calidad de TEXTO):
- **`.cdr` (CorelDraw) vía `cdr2text`** → **texto más limpio**: títulos perfectos, **0 ligaduras**,
  **0 letra-espaciada**, orden de lectura correcto, con citas autor-fecha y notas al pie. **No**
  da estructura (encabezados/listas/tablas) ni imágenes. Requiere `brew install libcdr`.
- **`.docx` vía `pandoc`** → cuerpo limpio + **niveles de encabezado** + las **62 imágenes**
  incrustadas; pero títulos decorativos rotos y ligaduras `ﬁ/ﬂ`. Útil para estructura e imágenes.
- **PDF** → capa de texto **rota** en fuentes decorativas («EDUTIVO», «DCRIPCIÓN»…): solo sirve
  para ver la **maquetación** de referencia, no para copiar texto.

**Herramienta:** `bash scripts/ingerir.sh [ruta.cdr] [ruta.docx]` deja en `_origen/ingesta/`
(gitignored): `guia-texto.txt` (texto limpio del CDR), `guia-docx.md` (estructura de referencia)
y `media/` (62 imágenes del docx).

Proceso recomendado, **sección a sección**:

1. `bash scripts/ingerir.sh` → trabaja sobre `_origen/ingesta/guia-texto.txt`.
2. Localiza la sección (mapa de páginas en `capitulos/README.md`) y **transcribe** su contenido
   al `.md` del capítulo dándole estructura Markdown (encabezados con el título canónico, listas,
   tablas, énfasis, blockquotes para las citas textuales). Para **tablas/listas** (Anexo I, tarjetas
   de la sección 5) contrasta con `guia-docx.md`, que preserva mejor esa estructura.
3. Mapea las imágenes a `assets/` / `figures/` (las relevantes ya están curadas en `assets/`;
   `_origen/ingesta/media/` tiene las 62 incrustadas por si falta alguna).
4. Convierte las referencias autor-fecha del texto a citas `[@clave]` contra `references.bib`.
5. Borra el comentario `<!-- INGESTA: … PENDIENTE -->` del stub al terminar y revisar la sección.
6. `make pdf` y revisa el resultado.

## Figuras

- **Fotografías/ilustraciones** (retratos, póster AI4K12): versionadas en `assets/imagenes/` y
  referenciadas como imagen normal `![Pie](assets/imagenes/IMAG_X.png){width=…}`.
- **Diagramas** (fases de aprendizaje automático, red neuronal de §3): **TikZ vectorial** escrito
  directamente en el `.md` dentro de bloques ```` ```{=latex} ```` (estilos `ball`/`neuron`/`lbl`/`conn`
  definidos en el preámbulo de `generar-pdf.sh`). Se renderizan en el **PDF**; el **DOCX** no
  incluye el TikZ (pandoc descarta el LaTeX crudo).
- **Extraer una figura del `.cdr`** (si hace falta una nueva): con LibreOffice instalado,
  `soffice --headless --convert-to pdf --outdir /tmp ruta.cdr` rinde el original fiel (43 págs);
  luego `pdftoppm -f N -l N -r 300 -x .. -y .. -W .. -H .. -png …` recorta la región. Útil como
  referencia para recrear en TikZ o para usar el PNG directamente.
- **Peso del PDF:** el build aplica `pandoc/optimize-images.lua` (solo en el PDF), que reescala
  cada foto a **~300 dpi** según su `width` y la convierte a **JPEG q85** en una caché temporal
  (los PNG originales de `assets/` no se tocan). Reduce el PDF ~8×. Requiere **ImageMagick** o
  `sips` (macOS); si no hay ninguno, degrada con elegancia usando los PNG originales (PDF más
  pesado pero válido). Los **PNG de `assets/`** se optimizan sin pérdida con `oxipng -o max --strip safe`.

## Bibliografía

- **Editar a mano** `references.bib` (añadir/quitar/corregir entradas). Tras editar, regenera
  el índice legible: `make fuentes` (reescribe `fuentes/README.md` en APA desde el `.bib`).
- **Limpieza pendiente:** varias entradas tienen el autor institucional partido como nombre
  personal (p. ej. «Europea, C.» por «Comisión Europea»). Para corregir, envuelve el autor
  corporativo en dobles llaves en el `.bib`: `author = {{Comisión Europea}}`.
- **Re-exportación puntual desde Zotero** (opcional, NO es parte del build). La colección vive
  en el grupo ATE (id `5392796`), colección «Guía IA» (`RKCXID3Q`). Para volcar de nuevo el
  BibTeX completo (sobrescribe el `.bib`; revisa el diff antes de commitear):
  ```bash
  curl -sS "https://api.zotero.org/groups/5392796/collections/RKCXID3Q/items/top?format=bibtex&limit=100&key=$ZOTERO_API_KEY" > references.bib
  ```
  La clave NO se versiona: pásala por `ZOTERO_API_KEY` (p. ej. en `.env`, `gitignored`).

## Releases

- **`v1.0` (publicada actual):** sube el PDF maquetado original como **adjunto** de la release
  `v1.0` en GitHub (no va en el árbol de fuentes). Es la guía tal cual se publicó.
- **`preview` (automática):** cada push a `main` reconstruye el PDF y refresca una pre-release
  rodante `preview` con `pdf/*.pdf` + `SHA256SUMS`. No es una versión etiquetada.
- **Nuevas versiones** (cuando la guía esté reconstruida en LaTeX): etiqueta y publica a mano:
  ```bash
  git tag v1.1 && git push --tags     # luego crea la release en GitHub adjuntando pdf/…
  ```
  Actualiza también `version`/`date-released` en `CITATION.cff`.

## Qué NO se versiona (y por qué)

| No versionado | Motivo |
|---|---|
| `pdf/`, `docx/` | Artefactos reconstruibles (`make pdf`); se publican como release |
| `fuentes/*` (salvo `README.md`) | PDFs de terceros con copyright; se enlazan por DOI/URL |
| `_origen/` | Carpeta de trabajo de la ingesta (regenerable con `scripts/ingerir.sh`) |
| `.env`, `.claude/settings.local.json`, `.DS_Store` | Secretos/ajustes locales / basura del SO |

## Estado y hoja de ruta

**Hecho:** esqueleto + pipeline LaTeX (pandoc+tectonic) con **dos temas** (`lectura` sobrio /
`impresion` réplica); ingesta de las 8 secciones; tablas; citas APA + bibliografía; figuras
(3 fotos en `assets/` + 4 diagramas TikZ); logos (Gobierno, CC); recuadros `.nota`/`.definicion`;
tipografías libres versionadas; optimización (oxipng + imágenes a 300 dpi/JPEG en el PDF);
tema `impresion` con **cubierta réplica** (FONDO_2 + «IA» + título display + logo), **portadillas
de sección a página completa con fondo full-bleed** (`titleclass page` + `eso-pic`, FONDO_1 con
velo oscuro y título en blanco; el contenido va en página blanca legible) y recuadros del original.

**Posibles mejoras futuras del tema `impresion` (opcionales):**
- **Fondos por sección variados**: cycle de `FONDO_1..5` por portadilla (hoy todas usan FONDO_1).
  Requiere seleccionar la imagen según un contador en el `\titleformat` (algo más enrevesado).
- **Fondo también en páginas de contenido**: solo viable con una capa clara semitransparente
  (scrim) bajo el texto, o texto claro; si no, se pierde legibilidad. Decidir caso por caso.
- El tema `lectura` se mantiene siempre con fondo blanco.
