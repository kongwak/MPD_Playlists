#!/bin/bash
#this script is designed to run daily (see cron).
#It uses mpc to create the following play lists
# 1) a random list of 20 songs for each genre
# 2) all tracks by a random Artist
# 3) all tracks in a random album
# 4) a random daily list of 50 songs
# 5) all tracks added recently (as determined by the RECENT variable)
#Written by Richard
#19 Feb 2022
#Added decade playlists Apr 2022
# 6) random playlists form decade a recording is released
#Global declaration

# find the date 50 days ago in iso 8601 format (YYYYmmdd - 20220219)
RECENT=$(date --date="50 days ago" +"%Y%m%d")

#GENRE Lists

# mpc list Genre | tr ";/" "\n" | sed 's/^ *//g' | awk NF | sort -u 
# mpc list Genre 
#     creates a list of all the Genres used in my library. I organise my library using beets
#     and the lastFM pluging grabs genres (and does a bad job) with wierd genres and
#     multiple genres seperated by ";". So I pipe it to tr (translate and delete command)
# | tr ";/" "\n" 
#    this replaces any "/" and ";" characters with a new line character so I end up with
#    one genre per line. I further clean it up with a pipe to sed
# | sed 's/^ *//g' 
#    this removes any leading spaces on a line. lastly I remove blank lines with a pipe to awk
# | awk NF 
#    remove blank lines
# | sort -u
#    I sort the list and return a list of unique genres 
# eg:
# > Alternative Rock
# > Americana
# > Bluegrass
# > Blues
# > Calypso
# > Celtic
#
#
# mpc search "(Genre contains \"$LINE\")" | shuf -n 20 | mpc add;
# mpc search "(Genre contains \"$LINE\")" 
#    searches for all songs containg the genre in the $LINE variable
# | shuf -n 20 
#    the shuffle command randomises the list and outputs 20 songs
# | mpc add;
#    add these songs the current current playlist ready to be saved 

#This sample code will print a list of all your Genres

#mpc list Genre | tr ";/" "\n" | sed 's/^ *//g' | awk NF | sort -u | while read -r LINE; do
#   echo "# > $LINE";
#done

#This sample code will create lists for genres containing the desired words. In this case it
# creates a list for all genres including the word Indie. eg Indie, Indie Rock, Indie Folk
 
#mpc list Genre '(Genre contains "Indie")' | tr ";/" "\n" | sed 's/^ *//g' | awk NF | sort -u | while read -r line; do 
#    mpc rm "t-$line";
#    mpc clear;
#    mpc search "(Genre contains \"$line\")" | shuf -n 5 | mpc add;
#    mpc save "t-$line";
#done

#create one genre play list per genre in the form "s-genre". eg t-folk

mpc list Genre | tr ";/" "\n" | sed 's/^ *//g' | awk NF | sort -u | while read -r LINE; do
    mpc rm "t-$LINE";
    mpc clear;
    mpc search "(Genre contains \"$LINE\")" | shuf -n 20 | mpc add;
    mpc save "t-$LINE";
done

#Artist of the day - find songs of a random artist

# "$(mpc list AlbumArtist | shuf -n 1)"
#   this command fragment creates a list of all the albumartists and shuffles the list and outputs one artist)

mpc rm "s-FeaturedArtist"
mpc clear
mpc findadd AlbumArtist "$(mpc list AlbumArtist | shuf -n 1)"
mpc save "s-FeaturedArtist"

#Album of the day - finds a random album:

mpc rm "s-FeaturedAlbum"
mpc clear
mpc findadd Album "$(mpc list Album | shuf -n 1)"
mpc save "s-FeaturedAlbum"

#Daily random music

mpc rm "s-Daily"
mpc clear
mpc listall | shuf -n 50 | mpc add
mpc save "s-Daily"


#music added RECENTlY

mpc rm "s-Recent"
mpc clear
mpc searchadd "(modified-since \"$RECENT\")"
mpc save "s-Recent"

#make random decade lists

# this lists all dates (yyyy0mm-dd)
# removes blank lines - awk NF
# grabs the first 3 numbers of the originaldate (eg 196 for the sixties) - should be the original release date as set by beets
# removes any 000 dates
# sorts for unique numbers and created the lists eg y-1960's

mpc list originaldate | awk NF | cut -c1-3 | awk '!/000/' | sort -u | while read -r LINE; do
        mpc rm "y-${LINE}0's";
        mpc clear;
        mpc search "(originaldate contains \"$LINE\")" | shuf -n 20 | mpc add;
        mpc save "y-${LINE}0's";
done



mpc clear
