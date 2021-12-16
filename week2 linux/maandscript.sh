
#! /bin/bash

i=0
oktober=/home/tom/oktober
fotofolder=/home/tom/fotofolder

#dit is een cleaning tool die de folder vooraf schoonmaakt voor gebruik van de copy tool
read -p "wil je de cleaning folder tool gebruiken [klik dan 1] >>>" i
#! /bin/bash

i=0
oktober=/home/tom/oktober
fotofolder=/home/tom/fotofolder

#dit is een cleaning tool die de folder vooraf schoonmaakt voor gebruik van de copy tool
read -p "wil je de cleaning folder tool gebruiken [klik dan 1] >>>" i
if [ "$i" -eq 1 ];
then
        if [ "$(ls -A /home/tom/"$oktobermaand")" ];
        then
                echo "This tool will clean the directory right now"
                cd "$oktobermaand"
                rm -r *.jpeg
                cd /home/tom
                echo "Done cleaning"
                echo ""
                ((i++))                                  #wordt gebruikt in een toekomstige for loop wanneer alle 12 maanden folders moeten worden gecleaned
        else                                             #dit was eerst voor binnen de loop bedoeld maar kon geen oplossing hiervoor vinden
                echo "Folder oktober is empty"
                echo ""                                  #mijn oplossing was voor aantal jpegs runt die for loop en dan +1 maar daar ben ik niet achter gekomen hoe dat moet
        fi
else
        echo "Oke geen probleem we zullen gelijk de foto's uit uw folder sorteren"
        echo ""
fi

#dit is waar je old file removal en copy van de files begint
cd "$fotofolder"
for f in *
do
        oktobermaand=$(date -r "$f" +%m)
        if [ -d "$oktobermaand" ]
        then
                echo "Ah we see that oktober is empty, initiating copy!!!"
                echo "You will now see which files have been copied"
                if [ "$oktobermaand" -le 13 ];
                then
                                cp -v "$f" /home/tom/"$oktobermaand"
                else
                                echo "fotofolder consists of young files only"
                fi

        else
                if [ "$oktobermaand" -le 13 ];
                then
                        if [ -d "$oktobermaand" ]
                        then
                                cp -v "$f" /home/tom/"$oktobermaand"
                        else
                                mkdir -p /home/tom/"$oktobermaand"
                                cp -v "$f" /home/tom/"$oktobermaand"
                        fi
                fi
        fi


        original=$(sudo md5sum "$HOME"/fotofolder/"$f" | cut -d " " -f1)
        new=$(sudo md5sum "$HOME"/"$oktobermaand"/"$f" | cut -d " " -f1)
        if [ "$original" = "$new" ]
        then
                rm "$f"
        else
                echo "Copy was niet gelukt"
        fi
done




