#! /bin/bash

# author:  Pierre Poulain
# date:    04/09/2014
# license: MIT License (MIT)

usage="
Usage: creation_planche_photos.sh photo_identite.jpg"

if [ -z "$1" ]
then
    echo "Un fichier image doit être fourni en argument."
    echo "$usage"
    exit 1
fi

if [ ! -f "$1" ]
then
    echo "L'argument doit être un fichier image existant."
    echo "$usage"
    exit 1
fi

checkpicture=$(file $1 | grep 'JPEG image')
if [ -z "$checkpicture" ]
then
    echo "L'argument doit être un fichier image au format JPG."
    echo "$usage"
    exit 1
fi

if [ -z $(which montage) ]
then
    echo "L'outil 'montage' d'imagemagick n'est pas installé."
    exit 1
fi

if [ -z $(which convert) ]
then
    echo "L'outil 'convert' d'imagemagick n'est pas installé."
    exit 1
fi


# photo d'identité : 3,5 cm en largeur x 4,5 cm en hauteur 
# ratio largeur / hauteur ~ 0.778
# taille du visage : entre 3,2 et 3,6 cm (soit 70 à 80% du cliché)
# du bas du menton au sommet du crâne (hors chevelure).

output="${1%.jpg}_planche.jpg"
echo "Création de la planche d'images $output à partir de $1"

# pour une très bonne qualité d'impression, 
# la photo d'identité initiale doit mesurer au moins 840 x 1080 px

montage             \
  -tile 4x2          \
  -geometry  840x1080+30+60 $1 $1 $1 $1 $1 $1 $1 $1 \
  -quality 90 $output

# annotation
# planche prévue pour une impression en 10 x 15 cm
message=$(date "+%d/%m/%Y %H:%M")" pour impression 10x15"
convert $output -fill black -pointsize 40 -font courier -annotate +30+40 "$message" $output


echo "Terminé"
