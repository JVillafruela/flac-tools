#hires2cd : downgrade hires music files to 16bit / 44.1 or 48 kHz
# for use on a smartphone (save space while retaining good quality)
#
#Usage : open a Powershell interpreter and type hires2cd.ps1
#source file encoding : USC-2 BE BOM
#PS handles the national characters in file names like "05. Slavonic Dances, op. 46 no. 5 - Skočná - Allegro vivace.flac"

#Utilities :
#eac3to.exe downloaded from https://eac3to.en.lo4d.com/windows http://madshi.net/eac3to.zip  
#SOX : http://sox.sourceforge.net/sox.html 
#sox --guard infile --bits 16 outfile rate 44100 dither -s  
#sox infile −b 16 outfile rate −s −a 44100 dither −s #very high quality resampling 

# 'sox' or 'eac3to'
$ENCODER='sox' 
#PATH=%PATH%;c:\Utils\_Audio\eac3\
#Encoder options : 48000 when encoding hires files at 96Khz/192Khz, 44100 if 88.2Khz
$RESAMPLE='44100' 

#Source directory can contain multiple CDs ripps in subdirectories CD1 ... CD9
$SOURCE="M:\Qobuz\_Anthologies\Terpsichore Muse of the Dance"
#Destination directory for flac cd files
#$DEST="M:\temp\_Anthologies\Love is strange. Works for Lute Consort"
$DEST=$SOURCE.Replace("\Qobuz","\temp")

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
		$filename=$_.BaseName.Replace("-SMR","") #SMR used by Qobuz on hires files
		$cdfile = $destdir+"\"+$filename+".flac"
		
		#echo "$flacfile" + " => " + "$cdfile" 
		if ($ENCODER -eq 'eac3to') {
			if($RESAMPLE -eq '' ) {	
				c:\Utils\_Audio\eac3\eac3to  "$flacfile"  "$cdfile" -down16
			} else {
				$optsample="-resampleto" + $RESAMPLE
				c:\Utils\_Audio\eac3\eac3to  "$flacfile"  "$cdfile" -down16 $optsample
			}
		}
		
		if ($ENCODER -eq 'sox') {
			if($RESAMPLE -eq '' ) {	
				C:\Utils\_Audio\sox\sox -S --guard "$flacfile" --bits 16 "$cdfile"  
			} else {
				C:\Utils\_Audio\sox\sox -S --guard "$flacfile" --bits 16 "$cdfile" rate $RESAMPLE dither -s
			}
		}		

	}
}
 
function cover ([string]$flacdir,[string]$oggdir) {
	$cover=$flacdir+"\cover.jpg"
	if(Test-Path -PathType Leaf $cover){
		Copy-Item -Path $cover -Destination $oggdir
	}
	
	$cover=$flacdir+"\back.jpg"
	if(Test-Path -PathType Leaf $cover){
		Copy-Item -Path $cover -Destination $oggdir
	}	
}


$cd=$SOURCE+"\CD1"
if(Test-Path -Path $cd ){
	# Music files in sub directories CD1,CD2 ... CD9 
	for ($i = 1; $i –lt 10; $i++) {
		$cd=$SOURCE+"\CD$i"
		if(Test-Path -Path $cd ){
			encode $SOURCE $DEST $i	
			cover $SOURCE $DEST 
		}
	}    
} else {
	encode $SOURCE $DEST
	cover $SOURCE $DEST 
}



