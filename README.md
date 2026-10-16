# La inteligencia artificial (IA) en el ámbito educativo

Repositorio para el **mantenimiento y generación** de la guía *«La inteligencia artificial
(IA) en el ámbito educativo»* (Área de Tecnología Educativa — Gobierno de Canarias).

El objetivo es **gestionar la guía como documento vivo**: el contenido se escribe en
Markdown (`capitulos/`), la bibliografía vive versionada en `references.bib`, los recursos
visuales en `assets/`, y un **build LaTeX reproducible** (`pandoc` + `tectonic`) produce un
**PDF de calidad** — sustituyendo la maquetación manual en CorelDraw — para poder ir
actualizando la guía en futuras versiones con todo indexado.

> **Estado:** esqueleto montado, pendiente de **ingerir** el contenido desde la guía
> original. La **versión 1.0** publicada (PDF) se distribuye como **adjunto de la release
> `v1.0`** de este repositorio, no dentro del árbol de fuentes.

## Estructura del repositorio

| Ruta | Qué es |
|---|---|
| [`capitulos/`](capitulos/) | **Fuente del documento** en Markdown, un fichero por sección (ver [`capitulos/README.md`](capitulos/README.md)) |
| [`metadata.yml`](metadata.yml) | Metadatos del documento (título, autoría, idioma, licencia) para pandoc |
| `references.bib` | **Bibliografía** (BibTeX) — fuente de verdad versionada (estilo APA 7) |
| `apa.csl` | Estilo de cita APA 7 (es) para citeproc |
| [`fuentes/`](fuentes/) | **Índice bibliográfico** legible (APA). Los PDF con copyright **no** se versionan |
| [`assets/`](assets/) | Recursos visuales propios de la guía: `iconos/`, `imagenes/`, `fondos/` (versionados); `tipografias/` (de marca, **no** versionadas) |
| `figures/` | Figuras/diagramas propios (preferible vectorial `.svg` → PNG en build) |
| `generar-pdf.sh` · `Makefile` | **Pipeline de build**: ensambla `capitulos/` → PDF + DOCX con bibliografía APA |
| `pandoc/zebra-tables.lua` | Filtro Lua para tablas con filas alternas (zebra) |
| `scripts/` | Utilidades (regenerar el índice de fuentes desde el `.bib`) |
| [`AGENTS.md`](AGENTS.md) | **Runbook**: reglas y dónde está cada procedimiento |
| [`.agents/skills/`](.agents/skills/) | Skills del repositorio. `.claude/skills/` es una copia completa |
| `.github/workflows/` | CI: construye el PDF en cada push y refresca una pre-release `preview` |

## Generar el PDF / DOCX

El mismo contenido (`capitulos/`) produce **dos PDF** con distinto *tema* visual:

- **`pdf/guia-ia-educacion-lectura.pdf`** — sobrio y legible (lectura en pantalla).
- **`pdf/guia-ia-educacion-impresion.pdf`** — réplica del estilo visual del original
  (portadillas de sección con la fuente *display*, etc.).

Ambos PDF utilizan **separación silábica automática en español** mediante la configuración
`lang: es` de Pandoc y las reglas tipográficas del preámbulo LaTeX compartido en
`generar-pdf.sh`, para evitar espacios excesivos en los párrafos justificados. Este ajuste
no modifica el DOCX ni los PDF generados con el motor alternativo LibreOffice.

```bash
make pdf            # DOCX + ambos PDF (lectura e impresión) en pdf/ y docx/
make docx           # solo DOCX (rápido, solo pandoc)
make fuentes        # regenera fuentes/README.md (índice APA) desde references.bib
make clean          # borra artefactos de pdf/ y docx/
# solo un tema:
bash generar-pdf.sh lectura      # o: impresion
```

Requiere `pandoc` y `tectonic` (`brew install pandoc tectonic`); no necesita TeX Live
completo. Los PDF se generan en `pdf/` y el DOCX en `docx/`; **son artefactos locales no
versionados** (se reconstruyen, y en CI se publican como pre-release `preview`).

## Bibliografía

- `references.bib` es la **fuente de verdad** versionada y se edita a mano. Se generó una
  vez a partir de la colección Zotero del grupo ATE («Guía IA»); **no hay sincronización
  automática**.
- `fuentes/README.md` es un **índice legible** en APA, derivado de `references.bib` con
  `make fuentes`.
- Los **PDF de las fuentes** con copyright **no** se redistribuyen; se identifican por
  DOI/URL. Si los necesitas en local, descárgalos dentro de `fuentes/` (está `gitignored`).

## Licencias

Todo el repositorio —contenido de la guía (texto, figuras, iconos) y tooling de construcción
(scripts, `Makefile`, filtros pandoc)— se publica bajo **Creative Commons
Atribución-NoComercial-CompartirIgual 4.0 Internacional (CC BY-NC-SA 4.0)**. El texto legal
íntegro y sin modificar está en [`LICENSE`](LICENSE).

**Obra de terceros** (conserva su propia licencia, no cubierta por la anterior):

- **Fuentes bibliográficas** citadas (PDFs): no se redistribuyen; se enlazan por DOI/URL en
  [`fuentes/README.md`](fuentes/) y `references.bib`.
- **Tipografías** incluidas en [`assets/tipografias/`](assets/tipografias/): bajo sus propias
  licencias libres (OFL 1.1 / Apache 2.0).
- Algunas **figuras de terceros** conservan su licencia propia, indicada en su pie/crédito
  (p. ej. el póster de AI4K12 «Cinco grandes ideas en IA», CC BY-NC-SA 4.0).

## Cómo citar

Este repositorio incluye [`CITATION.cff`](CITATION.cff); GitHub mostrará el botón **«Cite
this repository»**. Cita sugerida: *Área de Tecnología Educativa (2024). La inteligencia
artificial (IA) en el ámbito educativo. Consejería de Educación, Gobierno de Canarias.*

## Mantenimiento

Las convenciones de edición, el flujo de **ingesta** desde la guía original, la gestión de
la **bibliografía** y el proceso de **release** están en [`AGENTS.md`](AGENTS.md).
