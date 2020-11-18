<?php
require 'vendor/autoload.php';


$library = 'M:\_encodage';
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

    // echo "-- $composer $album \n";

    //if ($composer=='Bach') die("DDD");
	
	if ($level>=2) {
		if (!file_exists($dir . DIRECTORY_SEPARATOR . 'cover.jpg')) {
				echo "-- missing cover $composer $album \n";
		}
	}


    $d = dir($dir);
    while (false !== ($entry = $d->read()) ) {
        if ($entry=='.' || $entry=='..' ) continue;
        $path=$dir . DIRECTORY_SEPARATOR . $entry;
        if (is_dir($path)) {
            analyze_dir($path,$level+1);
        } 
    }
    $d->close();


}




