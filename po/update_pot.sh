#!/bin/bash
# Should run from project root dir

version=$(grep -F "version: " ./meson.build | grep -v "meson" | grep -o "'.*'" | sed "s/'//g")

find ./src -iname "*.vala" | xargs xgettext --add-comments --package-name="Foldy" --package-version="$version" --from-code=UTF-8 --output=./po/"foldy"-src.pot
find ./data/ui -iname "*.blp" | xargs xgettext --add-comments --package-name="Foldy" --package-version="$version" --from-code=UTF-8 --output=./po/"foldy"-blueprint.pot --keyword=_ --keyword=C_:1c,2 -L C
find ./data/ -iname "*.desktop.in" | xargs xgettext --add-comments --package-name="Foldy" --package-version="$version" --from-code=UTF-8 --output=./po/"foldy"-desktop.pot -L Desktop
find ./data/ -iname "*.appdata.xml.in" | xargs xgettext --no-wrap --package-name="Foldy" --package-version="$version" --from-code=UTF-8 --output=./po/"foldy"-appdata.pot

msgcat --sort-by-file --use-first --output-file=./po/"foldy".pot ./po/"foldy"-src.pot ./po/"foldy"-blueprint.pot ./po/"foldy"-desktop.pot ./po/"foldy"-appdata.pot

sed 's/#: //g;s/:[0-9]*//g;s/\.\.\///g' <(grep -F "#: " po/"foldy".pot) | sed s/\ /\\n/ | sort | uniq > ./po/POTFILES.in

rm ./po/"foldy"-*.pot

echo "# Please keep this list alphabetically sorted" > ./po/LINGUAS
for l in $(ls ./po/*.po); do basename $l .po >> ./po/LINGUAS; done

for file in ./po/*.po; do
    msgmerge --update --backup=none "$file" ./po/"foldy".pot
    msguniq "$file" -o "$file"
done

# To create language file use this command
# msginit --locale=LOCALE --input "foldy".pot
# where LOCALE is something like `de`, `it`, `es`...
# or use Poedit with "Create new"
