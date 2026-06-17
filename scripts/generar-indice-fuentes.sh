#!/usr/bin/env bash
#
# generar-indice-fuentes.sh — Regenera fuentes/README.md (índice humano de la
# bibliografía) a partir de references.bib, el .bib versionado y fuente de verdad.
#
# No consulta Zotero: usa pandoc + citeproc + apa.csl para renderizar TODA la
# bibliografía en estilo APA 7 (es) y la envuelve con la cabecera del índice.
#
# Uso:  bash scripts/generar-indice-fuentes.sh
# Requiere: pandoc.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$HERE"
command -v pandoc >/dev/null 2>&1 || { echo "ERROR: falta pandoc (brew install pandoc)"; exit 1; }
TODAY="$(date +%Y-%m-%d)"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# Driver: nocite '@*' fuerza a citeproc a listar TODAS las entradas del .bib.
cat > "$TMP/driver.md" <<'MD'
---
nocite: '@*'
lang: es
---
MD

# Renderiza la bibliografía completa en APA como Markdown (una entrada por línea).
pandoc "$TMP/driver.md" \
  --citeproc --csl=apa.csl --bibliography=references.bib \
  -M lang=es -t markdown_strict-raw_html --wrap=none \
  -o "$TMP/refs.md"

N="$(grep -c '^' "$TMP/refs.md" 2>/dev/null || echo 0)"

{
  echo "# Fuentes — índice bibliográfico de la guía"
  echo ""
  echo "Índice legible de las fuentes citadas en la guía, en estilo **APA 7 (es)**. La"
  echo "bibliografía canónica (BibTeX) está en [\`../references.bib\`](../references.bib) y es la"
  echo "**fuente de verdad** versionada del repositorio; **este índice se deriva de ella** y se"
  echo "regenera con \`scripts/generar-indice-fuentes.sh\`."
  echo ""
  echo "> **Los PDF/originales con copyright no se redistribuyen aquí.** Las fuentes se identifican"
  echo "> por DOI/URL; las de acceso abierto se descargan desde el enlace, las de pago a través de"
  echo "> tu institución. Para tener el material en local, descárgalo en esta carpeta (\`fuentes/\`):"
  echo "> los binarios están \`gitignored\` y no se suben al repositorio."
  echo ""
  echo "> Generado desde \`references.bib\` el ${TODAY}."
  echo ""
  echo "## Referencias"
  echo ""
  # Cada párrafo de refs.md es una entrada; las dejamos como lista con viñeta.
  awk 'NF{ if(p) print ""; print "- "$0; p=1 } !NF{ p=0 }' "$TMP/refs.md" \
    | awk '/^- /{print; next}{print}'
  echo ""
  echo "## Notas"
  echo ""
  echo "- La colección original vive en Zotero (grupo ATE, colección «Guía IA»). **No hay"
  echo "  sincronización automática**: \`references.bib\` se mantiene versionado y se edita a mano"
  echo "  (o se reemplaza con una re-exportación puntual; ver \`AGENTS.md\`)."
} > fuentes/README.md

echo "fuentes/README.md regenerado ($(grep -c '^- ' fuentes/README.md) entradas)."
