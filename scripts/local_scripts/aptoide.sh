#!/bin/bash

echo "##########################"
echo "###                    ###"
echo "##                      ##"
echo "#   Aptoide Downloader   #"
echo "##                      ##"
echo "###                    ###"
echo "##########################"

echo "Aptoide Downloader  Copyright (C) 2012  Cristian Stefanescu
    This program comes with ABSOLUTELY NO WARRANTY;
    This is free software, and you are welcome to redistribute it
    under certain conditions;  for details see LICENCE
    or visit http://www.gnu.org/licenses/"

### Cream directorul aptoide si-i salvam numele intr-o variabila ###
mkdir -p $HOME/aptoide
aptoide_home_dir=$(echo $HOME/aptoide)

### Schimbam link-ul HTTP in link-ul pentru telefoane mobile ###
link_http=$(echo $1 | sed 's/http:\/\//http:\/\/m./g')

### Salvam html-ul descarcat ca numele aplicatiei ###
fisier=$(echo $link_http | sed 's/\//\ /g' | awk '{print $NF}')
echo "3..."
wget $link_http -O /tmp/$fisier >/dev/null 2>&1

### Ne folosim de fisierul HTML pentru a cauta link-ul de download, ###
### apoi descarcam si salvam fisierul myapp ###
down=$(grep -i \<a\ class=\"app_install_button\" /tmp/$fisier | sed 's/<a class="app_install_button" href="//g' | sed 's/">Install<\/a>//g' | tail -2 | head -1 | sed 's/^[ \t]*//')
echo "2.."
wget $down -O /tmp/$fisier.myapp >/dev/null 2>&1
fisier_myapp=$(echo /tmp/$fisier.myapp)
echo "1."

### Din fisierul myapp facem rost de link-ul pentru *.apk si de numele aplicatiei, ###
### apoi salvam fisierul apk in directorul aptoide ###
apk_ul=$(cat $fisier_myapp | tail -1 | head -2 | sed 's/<[^>]*>/ /g' | awk '{print $(NF-4)}')
nume_apk=$(echo $fisier_myapp | tail -1 | head -2 | sed 's/%20/\ /g' | sed 's/.myapp//g' | sed 's/\/tmp\///g')
echo "Descarcam..."
wget -c -nc $apk_ul -O $aptoide_home_dir/$nume_apk.apk
echo "Fisier salvat!"

### Facem curat? Facem, chiar daca nu suntem din zodia Fecioarei ###
rm /tmp/$fisier 2>&1
rm $fisier_myapp 2>&1