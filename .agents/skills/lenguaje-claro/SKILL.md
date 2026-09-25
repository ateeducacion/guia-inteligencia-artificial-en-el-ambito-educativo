---
name: lenguaje-claro
description: Revisar prosa en castellano y quitar muletillas de modelo. Úsalo al editar instrucciones, un informe o una síntesis. En cláusulas de pliego o citas de norma, solo señala.
license: CC-BY-4.0
metadata:
  idioma: es
  tipo: redaccion
  version: "1.0"
  actualizado: 2026-09-25
---

# Lenguaje claro

Quita la prosa que delata un borrador de modelo y deja el contenido intacto. No añadas datos, nombres, fechas, citas ni requisitos que no estuvieran ya.

Hay dos modos:

- **Reescribir.** Instrucciones (`AGENTS.md`, un `SKILL.md`), informes y síntesis. Devuelve el texto y una lista corta de lo que cambió.
- **Detectar.** Cláusulas de PPT o PCAP, definiciones jurídicas y citas literales de una norma. Lista las frases. No las reescribas.

Si el usuario no dice el modo, detecta en pliegos y citas, y reescribe en el resto. En un archivo largo, pregunta qué sección.

Los ejemplos están en [references/patrones-es.md](references/patrones-es.md). Ábrelos al revisar. No hace falta memorizar la lista.

## Qué conservar

- Identificadores (`FTE-NNN`, `AN-NNN`, `DEC-NNNN`), rutas, artículos y cifras.
- La frase ya concreta. Si el párrafo está bien, dilo y no lo toques.
- El registro del género. Un informe de dirección puede ser directo. Una cláusula no se vuelve coloquial.

## Extensión

El texto cubre lo que la tarea pide. No añadas un resumen del resumen, ni una sección de contexto que repita el párrafo anterior.
