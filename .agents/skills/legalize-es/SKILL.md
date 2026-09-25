---
name: legalize-es
description: Localizar el texto vigente o una reforma de una norma española en el clon de legalize-dev/legalize-es. Úsalo cuando haya que citar el BOE y la norma no esté ya en las fuentes del repo.
license: CC-BY-4.0
metadata:
  idioma: es
  tipo: consulta
  corpus: https://github.com/legalize-dev/legalize-es
  version: "1.0"
  actualizado: 2026-09-25
---

# Legalize ES

El corpus es [legalize-dev/legalize-es](https://github.com/legalize-dev/legalize-es): legislación consolidada en Markdown, una norma por fichero y una reforma por commit. No es texto oficial. La versión que cita un artefacto se contrasta con el campo `fuente:` y con el BOE.

No hay skill upstream. El repositorio oficial no publica `SKILL.md`. Este fichero solo dice dónde está el clon y cómo no equivocarse de ruta.

## Clon

Si `.legalize-es/` no existe:

```bash
git clone --depth 1 https://github.com/legalize-dev/legalize-es.git .legalize-es
```

Ese directorio no se versiona. El repo pesa demasiado para meterlo en el proyecto. Para traer reformas nuevas: `git -C .legalize-es pull --ff-only`.

Dentro del clon solo `grep`, `git log`, `git show` y `git diff`. El README del clon manda sobre este skill si discrepan.

## Dónde está cada norma

- Estatal: `.legalize-es/es/BOE-A-AAAA-N.md`
- Autonómica: `.legalize-es/es-XX/`. Canarias es `es-cn`.

El identificador del fichero es el del BOE. El rango (ley, real decreto, ley orgánica) está en el frontmatter, no en la carpeta. Una guía antigua que busque en `spain/` está desactualizada: esa carpeta no existe.
