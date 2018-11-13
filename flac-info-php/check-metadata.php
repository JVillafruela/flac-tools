<?php
require 'vendor/autoload.php';

use bluemoehre\Flac;

$library = 'M:\audio\flac';
if (!is_dir($library)) {
    die("not a folder : $library");
}

analyze_dir($library, 0);

function analyze_dir($dir, $level)
{
    if (!is_dir($dir)) return;

    if ($level==1 && basename($dir)[0]=='_') return; // M:\audio\flac\_Film

    //echo "== $level $dir ==\n";
    if ($level==2) {
        $composer=basename(dirname($dir,1));
        $album=basename($dir);
    } elseif ($level==3) {
        $composer=basename(dirname($dir,2));
        $album=basename(dirname($dir,1)); 
    } else {
        $composer='';
        $album='';
    }

    //echo "-- $composer $album \n";

    //if ($composer=='Bach') die("DDD");

    $hascomposer=false;
    $hasartist=false;
    $fcomposer='';
    $fartist='';
    $filecount=0;

    $d = dir($dir);
    while (false !== ($entry = $d->read()) ) {
        if ($entry=='.' || $entry=='..' ) continue;
        $path=$dir . DIRECTORY_SEPARATOR . $entry;
        if (is_dir($path)) {
            analyze_dir($path,$level+1);
        } else {            
            if (strtolower(pathinfo($entry, PATHINFO_EXTENSION))=='flac') {
                //echo $entry."\n";
                $flac = new Flac($dir . DIRECTORY_SEPARATOR . $entry);
                $fcomposer=get_tag($flac,'composer');
                $fartist=get_tag($flac,'artist');
                $hascomposer=$hascomposer || !empty($fcomposer);
                $hasartist=$hasartist || !empty($fartist);
                $filecount++;
            }
        }
    }
    $d->close();

    if ($level>=2 && $filecount>0 && (!$hascomposer || !$hasartist)) {
        echo "! $composer $album -- $fcomposer $fartist\n";
    }
}


function has_tag(Flac $flac,$tag) {
    $comments=$flac->getVorbisComment()['comments'];
    return (key_exists($tag,$comments) && !empty($comments[$tag][0]));       
}

function get_tag(Flac $flac,$tag) {
    $comments=$flac->getVorbisComment()['comments'];
    if (!key_exists($tag,$comments)) return '';
    return  $comments[$tag][0];       
}