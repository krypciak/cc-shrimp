#!/bin/sh
set -e
BASE_NAME="$(jq '.id' ccmod.json | sed 's/^"//;s/"$//')"
NAME="${BASE_NAME}-$(jq '.version' ccmod.json | sed 's/^"//;s/"$//').ccmod"
rm -rf "$BASE_NAME"*
mkdir -p pack
cp -rf icon.png LICENSE ./pack
[ -d ./assets ] && cp -r assets ./pack
[ -d ./lang ] && cp -r lang ./pack
[ -d ./json ] && cp -r json ./pack

cd ./pack
for file in $(find . -iname '*.json') $(find . -iname '*.json.patch') $(find . -iname '*.json.patch.cond'); do
    jq '.' ../$file -c > $file
done
cp ../ccmod.json .
LIST="$(find . -name '*.kra') $(find . -name '*~')"
rm -rf $LIST
zip -r "../$NAME" .
cd ..
rm -rf pack
