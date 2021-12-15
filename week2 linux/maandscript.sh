#! /bin/bash

maand=/home/tom/fotofolder
for f in i=1
do
        cd $maand
        pwd
        for f in *
        do
                if [ -d $maand ]
                then 
                        if [ -d /home/tom/oktober ]
                        then
                                echo "het is succesvol gecopied"
                        else
                                cd /home/tom
                                mkdir oktober
                                find /home/tom/fotofolder -type f -mtime +30 -exec cp -f {} /home/tom/oktober \;
                        fi
                fi

                foto=$(sudo md5sum "$HOME"/fotofolder/"$f" | cut -d " " -f1)
                okt=$(sudo md5sum "$HOME"/oktober/"$f" | cut -d " " -f1)
                if [ "$foto" = "$okt" ]
                then
                        rm "$f"
                else
                        echo "Copy was niet gelukt"
                fi
        done
done



#ik mis nog een aantal dingen in plaats van dat ik -mtime +30 gebruikt voor de files ouder 
#dan 30 dagen wat op een andere manier moet want het moet namelijk per maand worden en niet alles in 1 folder

#ik mis nog het gebruik van md5sum doormiddel van md5sum zou je dan kunnen kijken wat er verwijderd moet worden in de oude map wanneer iets is gecopied in de nieuwe map
#ik heb het zover voor elkaar gekregen dat alles ouder is dan 30 dagen verwijderd wordt in de oude folder en in de nieuwe folder blijft staan / wordt gecopied
#ik heb daarnaast tijdens het uitvoeren van het script nog wat errors gekregen door de for loop omdat ie nu 6* checkt (omdat ik 6 .jpeg files heb) en in de nieuwe oktober folder
#niet 6 files staan, maar dit hinderd de werking niet hij copied en verwijderd nog wel gewoon zoals het hoort.
#ik had ook met user input kunnen werken, maar dit lijkt met niet nodig en is nog een stuk moeilijker

#verder moet ik nog een situatie maken waarin het niet lukt 
#ik snap erg veel wat alles betekent en wat het doet alleen vind ik het erg lastig om alles te implementeren op de juiste manier

#ik heb daarom ook vanwege gebrek aan tijd dit niet af kunnen krijgen, ik struggle erg veel met het opzoeken en uitvoeren van de kennis die ik opdoe tijdens dit proces
#ik ben 2 dagen volop hiermee bezig geweest alleen heb ik het niet af kunnen krijgen, ik vind het namelijk erg leuk met linux te werken alleen moet ik zo ontzettend veel
#opzoeken vanwege de gebrek aan kennis dat het mij simpelweg niet lukt om alle geleerde kennis toe te passen.

#Jeffrey en ik zijn op een gegeven moment ook bijeen gekomen om te kijken of we elkaar konden helpen


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#! /bin/bash

i=0
oktober=/home/tom/oktober
fotofolder=/home/tom/fotofolder

#dit is een cleaning tool die de folder vooraf schoonmaakt voor gebruik van de copy tool
read -p "wil je de cleaning folder tool gebruiken [klik dan 1] >>>" i
if [ "$i" -eq 1 ];
then
        if [ "$(ls -A /home/tom/oktober)" ];
        then
                echo "This tool will clean the directory right now"
                cd "$oktober"
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
        if [ -d "$oktober" ]
        then
                echo "Ah we see that oktober is empty, initiating copy!!!"
                echo "You will now see which files have been copied"
                if [ "$oktobermaand" -le 13 ];
                then
                                cp -v "$f" "$oktober"
                else
                                echo "fotofolder consists of young files only"
                fi

        else
                mkdir /home/tom/oktober
                echo "oktober dir has been made"
                cp -v "$f" "$oktober"
        fi


        original=$(sudo md5sum "$HOME"/fotofolder/"$f" | cut -d " " -f1)
        new=$(sudo md5sum "$HOME"/oktober/"$f" | cut -d " " -f1)
        if [ "$original" = "$new" ]
        then
                rm "$f"
        else
                echo "Copy was niet gelukt"
        fi
done




