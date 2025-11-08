#!/bin/bash
set -euo pipefail

# ====== Parámetros ======
IMAGES_PER_CLASS="${IMAGES_PER_CLASS:-8}"   # Cambia este valor (>=4). Ej.: 10 -> 70 imágenes totales
MIN_BYTES=10240                              # 10KB mínimo para considerar válida una descarga
opt=--no-verbose
UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"

ROOT="fake_imagenet"
VAL="$ROOT/val"
mkdir -p "$VAL"
cd "$VAL"

echo "Descargando imágenes por clase (todas de Wikimedia Commons) ..."
echo "Objetivo por clase: ${IMAGES_PER_CLASS}"

# ====== Descargas: 4 fotos nítidas por clase ======
## 817 — sports car
wget $opt -U "$UA" -O 800px-817-sportscar-01.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Porsche-911-GT3-front.jpg?width=800"
wget $opt -U "$UA" -O 800px-817-sportscar-02.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/LaFerrari_front.jpg?width=800"
wget $opt -U "$UA" -O 800px-817-sportscar-03.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Porsche_911_GT3_RS_4.0_IAA_front.jpg?width=800"
wget $opt -U "$UA" -O 800px-817-sportscar-04.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Orange_Porsche_911_GT3_RS_Type_997_(front).jpg?width=800"

## 89 — sulphur-crested cockatoo (Cacatua galerita)
wget $opt -U "$UA" -O 800px-089-cockatoo-01.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Sulphur-crested_Cockatoo.jpg?width=800"
wget $opt -U "$UA" -O 800px-089-cockatoo-02.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Sulphur-crested_cockatoo_-_Cacatua_galerita.JPG?width=800"
wget $opt -U "$UA" -O 800px-089-cockatoo-03.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Cacatua_galerita_18092009.jpg?width=800"
wget $opt -U "$UA" -O 800px-089-cockatoo-04.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Sulphur-crested_Cockatoo_(Cacatua_galerita).jpg?width=800"

## 13 — junco (Dark-eyed junco)
wget $opt -U "$UA" -O 800px-013-junco-01.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Dark_Eyed_Junco_(189420201).jpeg?width=800"
wget $opt -U "$UA" -O 800px-013-junco-02.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Dark_Eyed_Junco_(197460705).jpeg?width=800"
wget $opt -U "$UA" -O 800px-013-junco-03.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Dark-eyed_junco_(21840).jpg?width=800"
wget $opt -U "$UA" -O 800px-013-junco-04.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Dark-eyed_junco_(21854).jpg?width=800"

## 207 — golden retriever
wget $opt -U "$UA" -O 800px-207-golden-01.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Wet_Golden_Retriever_portrait.jpg?width=800"
wget $opt -U "$UA" -O 800px-207-golden-02.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/GoldenRetrieverPortrait.jpg?width=800"
wget $opt -U "$UA" -O 800px-207-golden-03.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Golden_Retriever_close_up.jpg?width=800"
wget $opt -U "$UA" -O 800px-207-golden-04.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Golden_Retriever_standing_Tucker.jpg?width=800"

## 156 — Blenheim spaniel (Cavalier King Charles, variedad Blenheim)
wget $opt -U "$UA" -O 800px-156-blenheim-01.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Cavalier_King_Charles_Spaniel_Blenheim_1.jpg?width=800"
wget $opt -U "$UA" -O 800px-156-blenheim-02.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Cavalier_King_Charles_Spaniel_Blenheim_Spot.jpg?width=800"
wget $opt -U "$UA" -O 800px-156-blenheim-03.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Cavalier-blenheim.jpg?width=800"
wget $opt -U "$UA" -O 800px-156-blenheim-04.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Cavalier_King_Charles_Spaniel_Blenheim_2.jpg?width=800"

## 233 — Bouvier des Flandres
wget $opt -U "$UA" -O 800px-233-bouvier-01.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Bouvier_des_Flandres_2016.jpg?width=800"
wget $opt -U "$UA" -O 800px-233-bouvier-02.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Bouvier_des_Flandres.jpg?width=800"
wget $opt -U "$UA" -O 800px-233-bouvier-03.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Bouvier_des_Flandres036.JPG?width=800"
wget $opt -U "$UA" -O 800px-233-bouvier-04.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Bouvier_980.jpg?width=800"

## 285 — Egyptian Mau
wget $opt -U "$UA" -O 800px-285-mau-01.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Egyptian_Mau_Cat.jpg?width=800"
wget $opt -U "$UA" -O 800px-285-mau-02.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Egyptian_Mau_Bronze.jpg?width=800"
wget $opt -U "$UA" -O 800px-285-mau-03.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Egyptian-mau-Face.jpg?width=800"
wget $opt -U "$UA" -O 800px-285-mau-04.jpg "https://commons.wikimedia.org/wiki/Special:FilePath/Egyptian_mau_-_Horus_2.jpg?width=800"

# ====== Validación básica ======
echo "Verificando descargas (> ${MIN_BYTES} bytes)..."
bad=0
for f in *; do
  [[ -f "$f" ]] || continue
  if [[ ! -s "$f" || "$(stat -c%s "$f")" -lt ${MIN_BYTES} ]]; then
    echo "Archivo inválido: $f (eliminado)"; rm -f -- "$f"; bad=$((bad+1))
  fi
done
echo "Archivos inválidos eliminados: $bad"

# ====== Balanceo: duplica imágenes existentes hasta alcanzar IMAGES_PER_CLASS por clase ======
balance_class() {
  local prefix="$1" target="$2"
  local arr=($(ls -1 ${prefix}-*.jpg 2>/dev/null | sort || true))
  local have=${#arr[@]}
  if (( have == 0 )); then
    echo "ADVERTENCIA: no hay imágenes para ${prefix}, no puedo balancear."
    return
  fi
  local idx=1
  while (( have < target )); do
    local src="${arr[$(((idx-1)%${#arr[@]}))]}"
    local dst=$(printf "%s-%02d-copy.jpg" "$prefix" "$idx")
    cp -f -- "$src" "$dst"
    arr+=("$dst")
    have=${#arr[@]}
    idx=$((idx+1))
  done
}

# 7 clases (prefijos)
balance_class "800px-817-sportscar" "${IMAGES_PER_CLASS}"
balance_class "800px-089-cockatoo"   "${IMAGES_PER_CLASS}"
balance_class "800px-013-junco"      "${IMAGES_PER_CLASS}"
balance_class "800px-207-golden"     "${IMAGES_PER_CLASS}"
balance_class "800px-156-blenheim"   "${IMAGES_PER_CLASS}"
balance_class "800px-233-bouvier"    "${IMAGES_PER_CLASS}"
balance_class "800px-285-mau"        "${IMAGES_PER_CLASS}"

# Reporte por clase
report_class() {
  local prefix="$1"
  printf "%-28s %3d\n" "$prefix" "$(ls -1 ${prefix}-*.jpg 2>/dev/null | wc -l)"
}
echo "Resumen por clase (objetivo=${IMAGES_PER_CLASS} c/u):"
report_class "800px-817-sportscar"
report_class "800px-089-cockatoo"
report_class "800px-013-junco"
report_class "800px-207-golden"
report_class "800px-156-blenheim"
report_class "800px-233-bouvier"
report_class "800px-285-mau"

cd ..

# ====== val_map.txt SOLO con archivos presentes y balanceados ======
echo "Generando val_map.txt..."
> val_map.txt

append_if(){
  local path="$1" id="$2"
  if [[ -f "$path" ]]; then echo "$path $id" >> val_map.txt; fi
}

# función para volcar en orden alfabético (estable) todos los archivos de un prefijo con su id
dump_class(){
  local prefix="$1" id="$2"
  for f in $(ls -1 "val/${prefix}-"*.jpg 2>/dev/null | sort); do
    append_if "$f" "$id"
  done
}

dump_class "800px-817-sportscar" 817
dump_class "800px-089-cockatoo"  89
dump_class "800px-013-junco"     13
dump_class "800px-207-golden"    207
dump_class "800px-156-blenheim"  156
dump_class "800px-233-bouvier"   233
dump_class "800px-285-mau"       285

echo "Listo."
echo "Total imágenes mapeadas:"
wc -l val_map.txt
echo "Primeras líneas:"
head -n 12 val_map.txt
