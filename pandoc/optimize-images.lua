-- optimize-images.lua — Reduce el peso del PDF: reescala cada imagen raster a ~300 dpi
-- (según su atributo width) y la convierte a JPEG q85 en un directorio de caché.
-- Los originales en assets/ NO se modifican; solo se reescriben las rutas hacia las copias.
-- Solo afecta a imágenes Markdown (las fotos); los logos van por \includegraphics (raw LaTeX)
-- y no se tocan. Degrada con elegancia: si no hay convertidor (ImageMagick/sips), o la
-- conversión falla, deja la imagen original (el build nunca se rompe por esto).
--
-- Parámetros por entorno: IMG_CACHE (dir de caché), TEXTWIDTH_IN (ancho de texto en pulgadas).

local CACHE = os.getenv("IMG_CACHE") or ((os.getenv("TMPDIR") or "/tmp") .. "/guia-imgcache")
local TEXTWIDTH_IN = tonumber(os.getenv("TEXTWIDTH_IN")) or 6.5
local DPI = 300
local QUALITY = 85
local MAX_FALLBACK = 1200   -- px de lado mayor si la imagen no trae width en %

os.execute("mkdir -p '" .. CACHE .. "' 2>/dev/null")

-- Detectar convertidor una sola vez: ImageMagick (magick/convert) o sips (macOS).
local function has(cmd) return os.execute(cmd .. " >/dev/null 2>&1") end
local CONV
if has("magick -version") then CONV = "magick"
elseif has("convert -version") then CONV = "convert"
elseif has("sips --version") then CONV = "sips" end

local function exists(p) local f = io.open(p, "rb"); if f then f:close(); return true end return false end

local function longest_side(p)
  local mx, cmd = 0, nil
  if CONV == "sips" then cmd = "sips -g pixelWidth -g pixelHeight '" .. p .. "' 2>/dev/null"
  else cmd = "identify -format '%w %h' '" .. p .. "' 2>/dev/null" end
  local h = io.popen(cmd)
  if h then
    local o = h:read("*a"); h:close()
    for n in o:gmatch("(%d+)") do n = tonumber(n); if n and n > mx then mx = n end end
  end
  return mx
end

local function convert_cmd(src, out, target)
  if CONV == "sips" then
    return string.format(
      "sips -Z %d -s format jpeg -s formatOptions %d '%s' --out '%s' >/dev/null 2>&1",
      target, QUALITY, src, out)
  end
  return string.format(
    "%s '%s' -resize '%dx%d>' -quality %d '%s' >/dev/null 2>&1",
    CONV, src, target, target, QUALITY, out)
end

function Image(img)
  if not CONV then return nil end
  local src = img.src
  local ext = src and src:match("%.([%a]+)$")
  if not ext then return nil end
  ext = ext:lower()
  if ext ~= "png" and ext ~= "jpg" and ext ~= "jpeg" then return nil end
  if not exists(src) then return nil end

  -- ancho objetivo (px) = ancho de texto * 300 dpi * porcentaje del width
  local target
  local w = img.attributes.width
  local pct = w and w:match("^(%d+%.?%d*)%%$")
  if pct then target = math.floor(TEXTWIDTH_IN * DPI * (tonumber(pct) / 100) + 0.5)
  else target = MAX_FALLBACK end

  local ls = longest_side(src)
  if ls > 0 and target > ls then target = ls end   -- nunca ampliar
  if target < 1 then return nil end

  local key = src:gsub("[^%w]", "_") .. "_" .. target .. "_q" .. QUALITY .. ".jpg"
  local out = CACHE .. "/" .. key
  if not exists(out) then os.execute(convert_cmd(src, out, target)) end
  if exists(out) then img.src = out end
  return img
end
