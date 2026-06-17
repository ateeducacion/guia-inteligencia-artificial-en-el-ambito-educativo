# assets/tipografias/ — tipografías de la guía

Tipografías **libres** que reemplazan a las del PDF original (identificadas con `pdffonts`
sobre el publicado). Al ser OFL/Apache, **sí se versionan** y el build las usa, de modo que
el PDF se reproduce **sin instalar nada en el sistema**.

## Mapeo original → libre

| Uso en el original | Fuente original | Licencia orig. | Reemplazo libre (aquí) | Licencia |
|---|---|---|---|---|
| **Cuerpo de texto** | Calibri | propietaria (MS) | **Carlito** (`carlito/`) — *métricamente idéntica* | OFL 1.1 |
| Texto puntual | Helvetica / Arial | propietaria | **Arimo** (`arimo/`) — métricamente idéntica | Apache 2.0 |
| Texto puntual | Times New Roman | propietaria | **Tinos** (`tinos/`) — métricamente idéntica | Apache 2.0 |
| Títulos / decorativo | **Varino**, **Astromax** | comercial | **display/** (Michroma, Orbitron, Audiowide, Chakra Petch) — *aire* futurista, no idénticas | OFL 1.1 |

- **Carlito** es el clon libre de Calibri de métricas idénticas (mismos anchos); de hecho
  LibreOffice lo usa como sustituto automático de Calibri. Es lo más cercano posible a «idéntico».
- Las tipografías comerciales del original (de pago) **no se incluyen ni se usan**: las libres
  de la tabla las reemplazan por completo.

## Uso en el build

- **Cuerpo:** `generar-pdf.sh` fija `\setmainfont` a **Carlito** desde `carlito/` (si los
  ficheros existen; si no, degrada con elegancia a TeX Gyre Pagella). Así el PDF replica el
  cuerpo en Calibri del original.
- **Display (títulos):** el preámbulo define `\displayfont` apuntando a `display/Michroma.ttf`
  (elegida como la más parecida a Varino). Para probar otra (Orbitron/Audiowide/Chakra Petch),
  cambia esa línea en `generar-pdf.sh`.

## Procedencia

- Carlito, Michroma, Orbitron, Audiowide, Chakra Petch: Google Fonts (OFL 1.1) — ver `OFL.txt`.
- Arimo, Tinos: Google Fonts (Apache 2.0) — proyecto «Croscore».
