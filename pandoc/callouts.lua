-- callouts.lua — Mapea divs con clase a recuadros tcolorbox (reproducen los del original).
--   ::: {.nota}        -> caja con relleno lavanda (pasajes destacados)
--   ::: {.definicion}  -> apartado con barra de acento azul (definiciones/notas al margen)
-- Solo afecta al PDF (LaTeX crudo). En DOCX el contenido se conserva como texto normal
-- (los \begin/\end se descartan), de modo que el build nunca se rompe.

local ENVS = { nota = true, definicion = true }

function Div(el)
  for _, c in ipairs(el.classes) do
    if ENVS[c] then
      local out = { pandoc.RawBlock("latex", "\\begin{" .. c .. "}") }
      for _, blk in ipairs(el.content) do out[#out + 1] = blk end
      out[#out + 1] = pandoc.RawBlock("latex", "\\end{" .. c .. "}")
      return out
    end
  end
  return nil
end
