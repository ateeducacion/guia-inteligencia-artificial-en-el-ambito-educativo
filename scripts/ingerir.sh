#!/usr/bin/env bash
#
# ingerir.sh — Prepara el material para ingerir la guía ORIGINAL a capitulos/.
#
# Fuentes (de mejor a peor calidad de TEXTO):
#   - .cdr (CorelDraw)  -> cdr2text (libcdr): texto MÁS limpio (títulos perfectos, 0 ligaduras,
#                          0 letra-espaciada, orden de lectura correcto). NO da estructura
#                          (encabezados/listas/tablas) ni imágenes.
#   - .docx             -> pandoc: cuerpo limpio + niveles de encabezado + las 62 IMÁGENES
#                          incrustadas; títulos decorativos rotos y ligaduras (ﬁ/ﬂ).
#   - .pdf              -> capa de texto rota en fuentes decorativas; solo para ver maquetación.
#
# Estrategia: TEXTO del .cdr (cdr2text, ya denoised aquí) + IMÁGENES del .docx. La estructura
# (encabezados, listas, tablas, énfasis) y el mapeo de imágenes se ponen a mano al transcribir
# a capitulos/ (ver AGENTS.md). Salida en _origen/ingesta/ (gitignored).
#
# Uso:  bash scripts/ingerir.sh [ruta.cdr] [ruta.docx]
# Requiere: libcdr (brew install libcdr -> cdr2text) y pandoc.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$HERE"
G="$HOME/Downloads/GUIA_MAQUETADA"
CDR="${1:-$G/HISTÓRICO/28022024_GUÍA_IA_EN_EDUCACION.cdr}"
DOCX="${2:-$G/28_02_2024_GUÍA_IA_EN_EDUCACION.docx}"
OUT="$HERE/_origen/ingesta"        # gitignored (.gitignore: _origen/)
mkdir -p "$OUT"

# 1) TEXTO desde el .cdr (cdr2text) + limpieza de ruido (marcas «IA» decorativas y
#    números de página sueltos; colapsa líneas en blanco).
if command -v cdr2text >/dev/null 2>&1 && [[ -f "$CDR" ]]; then
  cdr2text "$CDR" 2>/dev/null \
    | perl -CSD -pe 's/[ \t]+$//' \
    | grep -vxE '[[:space:]]*IA[[:space:]]*' \
    | grep -vxE '[[:space:]]*[0-9]+[[:space:]]*' \
    | awk 'NF{print; b=0} !NF{if(!b)print; b=1}' \
    > "$OUT/guia-texto.txt"
  echo "texto:  $OUT/guia-texto.txt   ($(wc -w < "$OUT/guia-texto.txt") palabras) [cdr2text]"
else
  echo "AVISO: falta cdr2text (brew install libcdr) o el .cdr; me salto el texto del CDR."
fi

# 2) IMÁGENES desde el .docx (las 62 incrustadas) + markdown crudo como referencia de estructura.
if command -v pandoc >/dev/null 2>&1 && [[ -f "$DOCX" ]]; then
  pandoc "$DOCX" -t markdown --wrap=none --extract-media="$OUT" -o "$OUT/guia-docx.md" 2>/dev/null
  IMGS=$(find "$OUT/media" -type f 2>/dev/null | wc -l | tr -d ' ')
  echo "media:  $OUT/media/   ($IMGS imágenes) [docx]"
  echo "estr.:  $OUT/guia-docx.md   (markdown del docx, referencia de encabezados/listas)"
else
  echo "AVISO: falta pandoc o el .docx; me salto imágenes/estructura."
fi

echo ""
echo "Siguiente paso: transcribe sección a sección a capitulos/ (ver AGENTS.md):"
echo "  - texto limpio  -> $OUT/guia-texto.txt"
echo "  - tablas/listas -> contrasta con $OUT/guia-docx.md"
echo "  - imágenes      -> $OUT/media/ (o las curadas en assets/)"
