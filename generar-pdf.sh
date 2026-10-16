#!/usr/bin/env bash
#
# generar-pdf.sh — Genera el/los PDF y el DOCX de la guía desde el Markdown de capitulos/,
# sustituyendo la maquetación en CorelDraw por un build LaTeX reproducible.
#
# DOS SALIDAS (mismo contenido, distinto «tema» visual):
#   - guia-ia-educacion-lectura.pdf    : sobrio y legible (lectura en pantalla).
#   - guia-ia-educacion-impresion.pdf  : réplica del estilo visual de la guía original
#                                        (portadillas de sección con la fuente display, …).
#
# Cadena: pandoc + tectonic (LaTeX). Bibliografía: references.bib vía citeproc + apa.csl.
# Requiere: pandoc. Para PDF: tectonic (preferido) o LibreOffice (fallback, sin estilo).
#   brew install pandoc tectonic
#
# Uso:  bash generar-pdf.sh             # DOCX + ambos PDF
#       bash generar-pdf.sh docx        # solo DOCX (rápido)
#       bash generar-pdf.sh lectura     # DOCX + solo el PDF de lectura
#       bash generar-pdf.sh impresion   # DOCX + solo el PDF de impresión
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"
OUTPDF="$HERE/pdf"; OUTDOCX="$HERE/docx"; OUTMD="$HERE/md"; mkdir -p "$OUTPDF" "$OUTDOCX" "$OUTMD"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
TODAY="$(date +%Y-%m-%d)"
# Fecha del documento en formato "mes de año" (español), p. ej. "junio de 2026".
MESES_ES=(enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre)
FECHA_DOC="${MESES_ES[$((10#$(date +%m)-1))]} de $(date +%Y)"
SLUG="guia-ia-educacion"
BIB="$HERE/references.bib"
CSL="$HERE/apa.csl"
META="$HERE/metadata.yml"
READER="markdown-tex_math_dollars-tex_math_single_backslash"
TARGET="${1:-todo}"

case "$TARGET" in
  docx)                 TEMAS=() ;;
  lectura|impresion)    TEMAS=("$TARGET") ;;
  *)                    TEMAS=(lectura impresion) ;;
esac

command -v pandoc >/dev/null 2>&1 || { echo "ERROR: falta pandoc (brew install pandoc)"; exit 1; }
PDF_ENGINE=""; command -v tectonic >/dev/null 2>&1 && PDF_ENGINE="tectonic"
PDF_FAILURES=0
SOFFICE=""
if [[ -z "$PDF_ENGINE" ]]; then
  for s in "/Applications/LibreOffice.app/Contents/MacOS/soffice" \
           "$(command -v soffice 2>/dev/null || true)" "$(command -v libreoffice 2>/dev/null || true)"; do
    [[ -n "$s" && -x "$s" ]] && { SOFFICE="$s"; break; }
  done
fi
echo "pandoc:    $(pandoc --version | head -1)"
echo "motor PDF: ${PDF_ENGINE:+tectonic}${PDF_ENGINE:-${SOFFICE:+LibreOffice (fallback, sin estilo LaTeX)}}"
[[ -z "$PDF_ENGINE" && -z "$SOFFICE" ]] && echo "  (sin motor PDF: solo DOCX)"

# Figuras: regenera PNG desde SVG si hay convertidor; nunca bloquea el build.
if ls "$HERE"/figures/*.svg >/dev/null 2>&1; then
  if command -v rsvg-convert >/dev/null 2>&1; then
    for svg in "$HERE"/figures/*.svg; do rsvg-convert -w 2000 "$svg" -o "${svg%.svg}.png"; done
    echo "figuras:   PNG regenerados desde SVG (rsvg-convert)"
  elif command -v inkscape >/dev/null 2>&1; then
    for svg in "$HERE"/figures/*.svg; do inkscape "$svg" --export-type=png -w 2000 -o "${svg%.svg}.png" >/dev/null 2>&1; done
    echo "figuras:   PNG regenerados desde SVG (inkscape)"
  fi
fi

# --- Preámbulo COMÚN a ambos temas (el formato de \section lo pone cada tema) ---
cat > "$TMP/header-base.tex" <<'TEX'
% pandoc 3.9 envuelve los keywords del PDF en \xmpquote (de hyperxmp, no cargado);
% lo definimos como passthrough para que el build no falle por los metadatos.
\providecommand{\xmpquote}[1]{#1}
\usepackage{xcolor}
\definecolor{guialink}{HTML}{1A3E6E}   % azul marino sobrio para enlaces/títulos
\definecolor{shadecolor}{HTML}{F4F6F8}
\usepackage{microtype}
\frenchspacing
% Pandoc's lang=es enables Spanish hyphenation through Babel.
% Favor natural word breaks over wide gaps in justified text.
\hyphenpenalty=25
\setlength{\emergencystretch}{2em}
% Diagramas vectoriales (TikZ) de la guía — ver capitulos/03-tipos-de-ia.md.
\usepackage{tikz}
\usetikzlibrary{positioning,arrows.meta,shadows}
\definecolor{nblue}{HTML}{1B2A6B}
\tikzset{
  ball/.style={circle,draw=black!22,fill=black!6,align=center,inner sep=1pt,text=nblue,
               drop shadow={opacity=0.25,shadow xshift=0.6pt,shadow yshift=-1.3pt}},
  neuron/.style={circle,draw=black!28,fill=black!7,minimum size=0.92cm,inner sep=0,
               text=nblue,font=\bfseries\large,
               drop shadow={opacity=0.2,shadow xshift=0.5pt,shadow yshift=-1pt}},
  lbl/.style={text=nblue,font=\bfseries\footnotesize},
  conn/.style={black!55,thick},
}
% Tipografía: \setmainfont (Carlito ≈ Calibri) y \displayfont (Michroma ≈ Varino) se
% añaden tras este heredoc, con las rutas de assets/tipografias/ y degradación elegante.
% Código: ajustar líneas largas al margen
\usepackage{fvextra}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,breakanywhere,commandchars=\\\{\}}
% Tablas zebra (filtro pandoc/zebra-tables.lua) + reglas finas
\usepackage{etoolbox}
\usepackage{colortbl}
\definecolor{rowzebra}{HTML}{EEF3F7}
\arrayrulecolor{black!55}
\setlength{\arrayrulewidth}{0.5pt}
\AtBeginEnvironment{longtable}{\small}
\renewcommand{\arraystretch}{1.22}
% Pies de figura/tabla sobrios
\usepackage[font=small,labelfont=bf,labelsep=period]{caption}
% Listas algo más compactas
\usepackage{enumitem}
\setlist{topsep=3pt,itemsep=2pt,parsep=0pt}
% Recuadros/apartados (reproducen los del original): caja con relleno lavanda (.nota)
% y apartado con barra de acento azul (.definicion). Vía pandoc/callouts.lua.
\usepackage[most]{tcolorbox}
\definecolor{notabg}{HTML}{ECEBF6}
\definecolor{defbg}{HTML}{F2F4F8}
\newtcolorbox{nota}{colback=notabg,colframe=notabg,boxrule=0pt,arc=2.5pt,
  left=9pt,right=9pt,top=7pt,bottom=7pt,boxsep=0pt,before skip=8pt,after skip=8pt}
\newtcolorbox{definicion}{colback=defbg,colframe=guialink,boxrule=0pt,leftrule=3pt,
  sharp corners,left=9pt,right=9pt,top=6pt,bottom=6pt,boxsep=0pt,before skip=8pt,after skip=8pt}
% Subsecciones (comunes a ambos temas). El \section lo define cada tema.
\usepackage{titlesec}
\titleformat{\subsection}{\normalsize\bfseries}{\thesubsection}{0.5em}{}
\titleformat{\subsubsection}{\normalsize\bfseries\itshape}{\thesubsubsection}{0.5em}{}
% Título de portada (común; usa la fuente display)
\usepackage{titling}
\setlength{\droptitle}{-2em}
\pretitle{\begin{center}\LARGE\bfseries\color{guialink}\displayfont}
\posttitle{\par\vspace{5pt}{\color{guialink}\rule{0.92\textwidth}{0.7pt}}\end{center}\vspace{0.2em}}
\preauthor{\begin{center}\normalsize}
\postauthor{\par\end{center}}
\predate{\begin{center}\small\color{black!55}}
\postdate{\par\end{center}\vspace{1.1em}}
% Cabecera de página con el título corto
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0.4pt}
\fancyhead[L]{\footnotesize\itshape La IA en el ámbito educativo}
\fancyhead[R]{\footnotesize\thepage}
\fancypagestyle{plain}{\fancyhf{}\fancyhead[R]{\footnotesize\thepage}\renewcommand{\headrulewidth}{0pt}}
TEX

# --- Tipografías libres versionadas (assets/tipografias). Si faltan, degrada con elegancia. ---
FDIR_CARLITO="$HERE/assets/tipografias/carlito"
FFILE_DISPLAY="$HERE/assets/tipografias/display/Michroma.ttf"
if [[ -f "$FDIR_CARLITO/Carlito-Regular.ttf" ]]; then
  printf '\\setmainfont{Carlito-Regular.ttf}[Path=%s/,BoldFont=Carlito-Bold.ttf,ItalicFont=Carlito-Italic.ttf,BoldItalicFont=Carlito-BoldItalic.ttf]\n' "$FDIR_CARLITO" >> "$TMP/header-base.tex"
else
  printf '%s\n' '\IfFontExistsTF{TeX Gyre Pagella}{\setmainfont{TeX Gyre Pagella}}{}' >> "$TMP/header-base.tex"
fi
if [[ -f "$FFILE_DISPLAY" ]]; then
  printf '\\newfontfamily\\displayfont{Michroma.ttf}[Path=%s/]\n' "$(dirname "$FFILE_DISPLAY")" >> "$TMP/header-base.tex"
else
  printf '%s\n' '\providecommand{\displayfont}{}' >> "$TMP/header-base.tex"
fi

# Marca de agua "BORRADOR" en los builds de desarrollo (main): se aplica salvo que el HEAD
# sea exactamente un tag (release) o que se fije WATERMARK por entorno (WATERMARK= para quitarla).
# Así los PDF de main/CI (pre-release "preview") salen marcados; un release con tag, limpio.
if [[ -z "${WATERMARK+x}" ]]; then
  if git -C "$HERE" describe --exact-match --tags HEAD >/dev/null 2>&1; then WATERMARK=""; else WATERMARK="BORRADOR"; fi
fi
if [[ -n "${WATERMARK:-}" ]]; then
  printf '\\usepackage{draftwatermark}\n\\SetWatermarkText{%s}\n\\SetWatermarkScale{0.9}\n\\SetWatermarkColor[gray]{0.85}\n\\SetWatermarkAngle{55}\n' \
    "$WATERMARK" >> "$TMP/header-base.tex"
  echo "marca de agua: $WATERMARK"
fi

# Genera un JPEG reescalado (cross-platform: ImageMagick o sips). Devuelve 1 si no hay.
mk_jpeg () { # mk_jpeg <src> <out> <maxpx>
  if   command -v magick  >/dev/null 2>&1; then magick "$1" -resize "${3}x${3}>" -quality 85 "$2" 2>/dev/null
  elif command -v convert >/dev/null 2>&1; then convert "$1" -resize "${3}x${3}>" -quality 85 "$2" 2>/dev/null
  elif command -v sips    >/dev/null 2>&1; then sips -Z "$3" -s format jpeg -s formatOptions 85 "$1" --out "$2" >/dev/null 2>&1
  else return 1; fi
}

# --- Bloque específico de cada tema (se concatena al header común) ---
gen_header () { # gen_header <tema> -> $TMP/header-<tema>.tex
  local tema="$1"; local h="$TMP/header-$tema.tex"
  cp "$TMP/header-base.tex" "$h"
  if [[ "$tema" == impresion ]]; then
    # Fondos full-bleed (FONDO_1..5) reescalados a JPEG; se ALTERNAN por sección.
    local fondodir="$TMP"
    for n in 1 2 3 4 5; do
      mk_jpeg "$HERE/assets/fondos/FONDO_$n.png" "$TMP/fondo-$n.jpg" 1200 \
        || cp "$HERE/assets/fondos/FONDO_$n.png" "$TMP/fondo-$n.jpg" 2>/dev/null || true
    done
    cat >> "$h" <<'TEX'
% Contador que cicla FONDO_1..5 por portadilla.
\newcounter{fondoidx}\setcounter{fondoidx}{0}
\newcommand{\nextfondo}{\stepcounter{fondoidx}\ifnum\value{fondoidx}>5\setcounter{fondoidx}{1}\fi}
% Portadilla de sección: PÁGINA COMPLETA propia (titleclass page) con fondo full-bleed
% (alternando FONDO_1..5 + velo oscuro) y título en blanco. El contenido va en la página
% siguiente (fondo blanco, legible). El fondo se dibuja con tikz overlay anclado a la página
% (sin diferir a shipout, para que cada portadilla coja su FONDO correcto).
\titleclass{\section}{page}
\titleformat{\section}[display]
  {\centering\displayfont\color{white}}
  {\fontsize{44}{48}\selectfont\thesection}{0.5em}
  {\nextfondo\thispagestyle{empty}%
   \begin{tikzpicture}[remember picture,overlay]%
     \node[inner sep=0] at (current page.center) {\includegraphics[width=\paperwidth,height=\paperheight]{@FONDODIR@/fondo-\thefondoidx.jpg}};%
     \fill[black,opacity=0.34] (current page.south west) rectangle (current page.north east);%
   \end{tikzpicture}%
   \fontsize{20}{25}\selectfont\MakeUppercase}
\titlespacing*{\section}{0pt}{0.30\textheight}{1em}
% El original no lleva "Resumen" en cubierta: lo ocultamos en impresión.
\usepackage{environ}
\AtBeginDocument{\RenewEnviron{abstract}{}}
TEX
    # Cubierta réplica: imagen cósmica + «IA» + título + 3 puntos + logo del Gobierno.
    local cover="$HERE/assets/fondos/FONDO_2.png"
    local gov="$HERE/assets/logos/gobierno-canarias.png"
    local coverjpg="$TMP/cover-impresion.jpg"
    mk_jpeg "$cover" "$coverjpg" 1600 || coverjpg="$cover"
    cat >> "$h" <<'TEX'
\renewcommand{\maketitle}{%
  \begin{titlepage}\thispagestyle{empty}%
  \vspace*{0.3cm}%
  {\raggedleft\displayfont\color{guialink}\large LA INTELIGENCIA ARTIFICIAL (IA)\\[3pt]EN EL ÁMBITO EDUCATIVO\par}%
  \vspace{7pt}%
  {\raggedleft\tikz{\draw[guialink,line width=0.6pt] (0,0) circle (2.7pt);
     \fill[guialink] (0.34,0) circle (2.7pt); \fill[yellow!85!orange] (0.68,0) circle (2.7pt);}\par}%
  \vfill
  \begin{center}%
  \begin{tikzpicture}
    \node[inner sep=0] (bg) {\includegraphics[width=\textwidth]{@COVER@}};
    \node at (bg.center) {\displayfont\color{white}\fontsize{120}{120}\selectfont IA};
  \end{tikzpicture}%
  \end{center}%
  \vfill
  \begin{center}\includegraphics[width=0.16\textwidth]{@GOV@}\end{center}%
  \vspace{0.3cm}%
  \end{titlepage}%
}
TEX
    sed -i.bak "s#@COVER@#$coverjpg#g; s#@GOV@#$gov#g; s#@FONDODIR@#$fondodir#g" "$h" && rm -f "$h.bak"
  else
    # Lectura: encabezado sobrio con filete fino (estilo actual).
    cat >> "$h" <<'TEX'
\titleformat{\section}{\large\bfseries\color{guialink}}{\thesection}{0.6em}{}[{\color{black!12}\titlerule[0.5pt]}]
\titlespacing*{\section}{0pt}{1.25em}{0.4em}
TEX
  fi
}

# Ensamblar el cuerpo: capitulos/*.md en orden alfabético.
: > "$TMP/cuerpo.md"
for f in "$HERE"/capitulos/[0-9]*.md; do
  cat "$f" >> "$TMP/cuerpo.md"; printf '\n\n' >> "$TMP/cuerpo.md"
done
# Fecha del documento (colofón): @FECHA@ -> "mes de año" de la compilación.
sed -i.bak "s/@FECHA@/$FECHA_DOC/g" "$TMP/cuerpo.md" && rm -f "$TMP/cuerpo.md.bak"

cite=(--citeproc --bibliography="$BIB")
[[ -f "$CSL" ]] && cite+=(--csl="$CSL")

# Reescalado de imágenes a ~300 dpi + JPEG q85 solo para el PDF (optimize-images.lua).
export IMG_CACHE="$TMP/imgcache"
export TEXTWIDTH_IN="6.535"   # A4 (21cm) - 2*2.2cm de margen = 16.6cm ≈ 6.535 in

pdf_common=(
  "$META" "$TMP/cuerpo.md"
  --from "$READER" --to pdf --pdf-engine=tectonic
  --toc --toc-depth=3 -V toc-title=Índice
  --highlight-style=tango --lua-filter="$HERE/pandoc/zebra-tables.lua"
  --lua-filter="$HERE/pandoc/optimize-images.lua"
  --lua-filter="$HERE/pandoc/callouts.lua"
  -V lang=es -V geometry:margin=2.2cm -V fontsize=11pt -V linestretch=1.08
  -V colorlinks=true -V linkcolor=guialink -V citecolor=guialink -V urlcolor=guialink
  -V date="$FECHA_DOC"
  "${cite[@]}"
)
docx_common=(
  "$META" "$TMP/cuerpo.md"
  --from "$READER" --to docx --standalone --toc --toc-depth=3
  --metadata date="$FECHA_DOC" --metadata lang=es
  "${cite[@]}"
)

echo "== Guía =="
pandoc "${docx_common[@]}" -o "$OUTDOCX/$SLUG.docx"
echo "  docx -> $SLUG.docx ($(du -h "$OUTDOCX/$SLUG.docx" | cut -f1))"
# Guía en Markdown único (GFM, citas APA resueltas) para acompañar a los PDF en la release.
# El LaTeX crudo (diagramas TikZ) no se representa en GFM; sí el resto del texto, tablas y bibliografía.
pandoc "$META" "$TMP/cuerpo.md" --from "$READER" --to gfm "${cite[@]}" -o "$OUTMD/$SLUG.md"
echo "  md   -> $SLUG.md ($(du -h "$OUTMD/$SLUG.md" | cut -f1))"

for tema in ${TEMAS[@]+"${TEMAS[@]}"}; do
  out="$OUTPDF/$SLUG-$tema.pdf"
  if [[ "$PDF_ENGINE" == tectonic ]]; then
    gen_header "$tema"
    if pandoc "${pdf_common[@]}" --include-in-header="$TMP/header-$tema.tex" -o "$out" 2>"$TMP/err-$tema"; then
      echo "  pdf  -> $SLUG-$tema.pdf ($(du -h "$out" | cut -f1)) [tectonic]"
    else echo "  pdf  -> FALLO tectonic ($tema):"; sed -n '1,12p' "$TMP/err-$tema"; PDF_FAILURES=$((PDF_FAILURES+1)); fi
  elif [[ -n "$SOFFICE" ]]; then
    if "$SOFFICE" --headless --norestore --convert-to pdf --outdir "$OUTPDF" \
         -env:UserInstallation="file://$TMP/lo-$$-$RANDOM" "$OUTDOCX/$SLUG.docx" >/dev/null 2>&1 \
       && [[ -s "$OUTPDF/$SLUG.pdf" ]]; then
      mv "$OUTPDF/$SLUG.pdf" "$out"; echo "  pdf  -> $SLUG-$tema.pdf [LibreOffice, sin estilo]"
    else echo "  pdf  -> FALLO LibreOffice ($tema)"; PDF_FAILURES=$((PDF_FAILURES+1)); fi
  else
    echo "  pdf  -> OMITIDO ($tema): no hay motor PDF"; PDF_FAILURES=$((PDF_FAILURES+1))
  fi
done

echo "Listo."
echo "DOCX en: $OUTDOCX"; ls -1 "$OUTDOCX"/*.docx 2>/dev/null || true
echo "PDF  en: $OUTPDF";  ls -1 "$OUTPDF"/*.pdf  2>/dev/null || true

if [[ "$TARGET" != docx && "$PDF_FAILURES" -gt 0 ]]; then
  echo "ERROR: $PDF_FAILURES PDF(s) no se generaron correctamente." >&2
  exit 1
fi
