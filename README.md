# MPD_Playlists
A bash script to generate a range of random playlists for MPD, https://www.musicpd.org/. You will need mpc installed (https://www.musicpd.org/clients/mpc/), which is generally a recommended install when you install mpd.

This is a commented bash script to generate the following playlists. 

1. a random list of 20 songs for each genre
1. all tracks by a random Artist
1. a random album
1. a random list of 50 songs
1. all tracks added recently (as determined by the RECENT variable, last 50 days)
1. random playlists based on the decade a recording was released

It uses MPC (https://www.musicpd.org/clients/mpc/) and some common linux text processing tools like awk, sed and shuf to create the playlists from the embedded tags in you music files. These are generally installed by default for most Linux distributions, or are in your distributions package manager. 

Obviously, it assumes that you have tagged your music collection. I personally use beets to tag my music, https://beets.io/. It does a great job, but is quite technical and labour intensive. 

Tags I used: Album, Genre, AlbumArtist, originaldate

If your collection does not populate those tags, you can substitute them for your own tags. eg Artist for AlbumArtist and Date for OriginalDate.

*A note on Genres:* My Genres are populated by the LASTFM plugin for Beets. This can put multiple genres into the song's genre tag (eg, Punk; Indie Rock; Rock). The genres are seperated by a semi colon ';'. If you use multiple genres seperated by a different character, please adjust the script.

## Usage

1. Download the script.
1. Read it to ensure it is not doing anything malicious
1. make it executable
1. run the script

*Note:* running this script will clear you current MPD/MPC playlist

I personally use a cron job to run it once per day.
