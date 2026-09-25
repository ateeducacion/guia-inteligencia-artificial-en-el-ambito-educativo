# Bibliografía y releases

## Bibliografía

`references.bib` se edita a mano. No hay sincronización con Zotero. Tras editar, `make fuentes` reescribe `fuentes/README.md` en APA.

La lista de referencias del PDF la coloca citeproc en `capitulos/07-bibliografia.md` (div `#refs`). No se escribe a mano.

Un autor institucional partido como nombre personal se corrige con dobles llaves: `author = {{Comisión Europea}}`.

Volcar de nuevo el BibTeX desde Zotero sobrescribe `references.bib`. Revisa el diff antes de commitear. La clave no se versiona:

```bash
curl -sS "https://api.zotero.org/groups/5392796/collections/RKCXID3Q/items/top?format=bibtex&limit=100&key=$ZOTERO_API_KEY" > references.bib
```

## Releases

- `v1.0`: el PDF maquetado original va como adjunto de la release, no en el árbol.
- `preview`: cada push a `main` reconstruye el PDF y refresca la pre-release `preview`. Lleva marca de agua. No es una versión etiquetada.
- Una versión nueva se etiqueta a mano: `git tag v1.1 && git push --tags`, y se actualizan `version` y `date-released` en `CITATION.cff`.
