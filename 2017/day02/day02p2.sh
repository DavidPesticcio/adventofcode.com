#!/bin/bash


declare -i MAX_INT=$(perl -MPOSIX -le 'print LONG_MAX')

row=1
modulo=0

lowest=$MAX_INT
highest=0

modulo?() {
  item_this=$1
  item_next=$2

  if [ $(($item_this % $item_next)) -eq 0 ]
  then
    echo 0
  else
    echo 1
  fi
}

while read line
do
  read -r -a items <<< "$line"

  elements_this=$(seq 0 $((${#items[@]}-1)))

  echo "Processing row: $row"
  echo "Row cells     : ${items[@]}"
  echo "Row items     : ${#items[@]}"

  for element_this in $elements_this
  do
    item_this=${items[${element_this}]}

    elements_next=$(seq $(($element_this + 1)) $((${#items[@]}-1)))

    for element_next in $elements_next
    do
      item_next=${items[${element_next}]}

      if [ $item_this -lt $item_next ]
      then
        if [ $(modulo? $item_next $item_this) -eq 0 ]
	then
	  modulo="$(($modulo + $(($item_next / $item_this))))"
          echo " --> Modulo! - $item_next / $item_this = $(($item_next / $item_this))"
	fi
      fi

      if [ $item_this -gt $item_next ]
      then
        if [ $(modulo? $item_this $item_next) -eq 0 ]
	then
	  modulo="$(($modulo + $(($item_this / $item_next))))"
          echo " --> Modulo! - $item_this / $item_next = $(($item_this / $item_next))"
	fi
      fi

    done
  done

  echo

  row=$(($row + 1))
  total=$(($total + ($highest - $lowest)))

done <<EOF
798 1976 1866 1862 559 1797 1129 747 85 1108 104 2000 248 131 87 95
201 419 336 65 208 57 74 433 68 360 390 412 355 209 330 135
967 84 492 1425 1502 1324 1268 1113 1259 81 310 1360 773 69 68 290
169 264 107 298 38 149 56 126 276 45 305 403 89 179 394 172
3069 387 2914 2748 1294 1143 3099 152 2867 3082 113 145 2827 2545 134 469
3885 1098 2638 5806 4655 4787 186 4024 2286 5585 5590 215 5336 2738 218 266
661 789 393 159 172 355 820 891 196 831 345 784 65 971 396 234
4095 191 4333 161 3184 193 4830 4153 2070 3759 1207 3222 185 176 2914 4152
131 298 279 304 118 135 300 74 269 96 366 341 139 159 17 149
1155 5131 373 136 103 5168 3424 5126 122 5046 4315 126 236 4668 4595 4959
664 635 588 673 354 656 70 86 211 139 95 40 84 413 618 31
2163 127 957 2500 2370 2344 2224 1432 125 1984 2392 379 2292 98 456 154
271 4026 2960 6444 2896 228 819 676 6612 6987 265 2231 2565 6603 207 6236
91 683 1736 1998 1960 1727 84 1992 1072 1588 1768 74 58 1956 1627 893
3591 1843 3448 1775 3564 2632 1002 3065 77 3579 78 99 1668 98 2963 3553
2155 225 2856 3061 105 204 1269 171 2505 2852 977 1377 181 1856 2952 2262
EOF

echo "Checksum: $modulo"
