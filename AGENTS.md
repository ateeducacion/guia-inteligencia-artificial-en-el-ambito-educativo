# AGENTS.md

Runbook de la guía *«La inteligencia artificial (IA) en el ámbito educativo»*.

La guía es un documento vivo en Markdown que se compila a PDF con `pandoc` y `tectonic`. El PDF no se edita.

## Reglas

- El contenido está en `capitulos/*.md` y `metadata.yml`.
- La bibliografía está en `references.bib`. Se edita a mano. La lista del PDF la genera citeproc en `capitulos/07-bibliografia.md`.
- No se suben binarios con copyright ni tipografías de marca.
- El original maquetado vive fuera del repo. Lo que se traiga para trabajar va a `_origen/`, que no se versiona.
- Antes de dar por bueno un cambio de contenido o de build, `make pdf` termina sin error.

## Qué no se versiona

| Ruta | Motivo |
| --- | --- |
| `pdf/`, `docx/`, `md/` | Se reconstruyen. En CI se publican como pre-release `preview` |
| `fuentes/*` salvo `README.md` | PDFs de terceros. Se enlazan por DOI o URL |
| `_origen/` | Ingesta regenerable con `scripts/ingerir.sh` |
| `.legalize-es/` | Clon local del corpus de normas. Solo consulta |
| `.env`, `.claude/settings.local.json` | Secretos y ajustes locales |

## Dónde está el procedimiento

No hace falta leerlo para una corrección puntual.

- Compilar: [`.agents/skills/compilacion-pdf/SKILL.md`](.agents/skills/compilacion-pdf/SKILL.md)
- Transcribir el original: [`.agents/skills/ingesta-original/SKILL.md`](.agents/skills/ingesta-original/SKILL.md)
- Editar un capítulo o una cita: [`.agents/skills/redaccion-guia/SKILL.md`](.agents/skills/redaccion-guia/SKILL.md)
- Bibliografía y releases: [`.agents/references/bibliografia-y-releases.md`](.agents/references/bibliografia-y-releases.md)

## Skills

`.agents/skills/` es el árbol canónico. `.claude/skills/` es una copia completa, archivo por archivo. Al cambiar un skill local:

```bash
rsync -a --delete --exclude .DS_Store --exclude .venv .agents/skills/ .claude/skills/
```

- `redaccion-guia`, `ingesta-original`, `compilacion-pdf`: el trabajo de este repositorio.
- `lenguaje-claro`: prosa en castellano. En una cita textual, solo señala.
- `legalize-es`: texto consolidado de [legalize-dev/legalize-es](https://github.com/legalize-dev/legalize-es), clonado en `.legalize-es/` y sin versionar. Dentro solo `grep`, `git log`, `git show` y `git diff`. Una cita de norma se contrasta con el BOE.

Los skills de terceros se instalan con `gh skill install OWNER/REPO PATH --dir .agents/skills`. El origen está en [`.agents/upstream-skills.txt`](.agents/upstream-skills.txt). Se mantienen verbatim. [`.github/workflows/update-agent-skills.yml`](.github/workflows/update-agent-skills.yml) los actualiza cada lunes y abre un pull request. No fusiona solo.

| Skill | Origen | Licencia |
| --- | --- | --- |
| `github-actions-hardening` | [`github/awesome-copilot`](https://github.com/github/awesome-copilot) `skills/github-actions-hardening` | MIT |

El aviso del corpus legal está en [`.agents/licenses/legalize-es-NOTICE.txt`](.agents/licenses/legalize-es-NOTICE.txt).
