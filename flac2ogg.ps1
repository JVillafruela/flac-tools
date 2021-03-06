#flac2ogg : encode flac music files into ogg files
#Usage : open a Powershell interpreter and type .\flac2ogg.ps1
#source file encoding : USC-2 BE BOM
#PS handles the national characters in file names like "05. Slavonic Dances, op. 46 no. 5 - Skočná - Allegro vivace.flac"

#Utilities :
#oggenc2 downloaded from http://www.rarewares.org/ogg-oggenc.php (required in the PATH)
#metaflac  https://xiph.org/flac/download.html (optional)
#mediainfo CLI https://mediaarea.net/fr/MediaInfo/Download/Windows (optional)

#Encoder options
# -q 9 320kb/s 
$QUALITY=9
# Add --resample 48000 when encoding hires files at 96Khz/192Khz. Not necessary if you start from a CD ripp (44100 Hz)
$RESAMPLE=''

#Source directory can contain multiple CDs ripps in subdirectories CD1 ... CD9
$SOURCE="M:\audio\flac\Bartók\Bartók- Concerto pour Orchestre , Janáček- Sinfonietta"
#Destination directory for ogg files
$DEST="M:\audio\mp3\_encodage\Bartók- Concerto pour Orchestre , Janáček- Sinfonietta"

function encode ([string]$flacdir,[string]$oggdir,[int]$cd=0) {
	if ($cd -eq 0) {
		$srcdir=$flacdir
		$destdir=$oggdir
	} else {
		$srcdir=$flacdir+"\CD"+$cd
		$destdir=$oggdir+"\CD"+$cd
	}
	
	if(!(Test-Path -Path $srcdir )){
		New-Item -ItemType directory -Path $srcdir
	}

	if(!(Test-Path -Path $destdir )){
		New-Item -ItemType directory -Path $destdir
	}

	Get-ChildItem $srcdir -Filter *.flac | 
	Foreach-Object {
		$flacfile=$_.FullName
		$oggfile = $destdir+"\"+$_.BaseName+".ogg"
		#echo "$flacfile" + " => " + "$oggfile" 
		if($RESAMPLE -eq '' ) {		
			oggenc2.exe -q $QUALITY "$flacfile" -o  "$oggfile" 
		} else {
			oggenc2.exe --resample $RESAMPLE -q $QUALITY "$flacfile" -o  "$oggfile" 
		}
	}
}


$cd=$SOURCE+"\CD1"
if(Test-Path -Path $cd ){
	# Music files in sub directories CD1,CD2 ... CD9 
	for ($i = 1; $i –lt 10; $i++) {
		$cd=$SOURCE+"\CD$i"
		if(Test-Path -Path $cd ){
			encode $SOURCE $DEST $i	
		}
	}    
} else {
	encode $SOURCE $DEST
}



