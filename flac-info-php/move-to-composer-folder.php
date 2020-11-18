<?php
require 'vendor/autoload.php';


$library = 'M:\_encodage';
if (!is_dir($library)) {
    die("not a folder : $library");
}

$d = dir($library );
while (false !== ($entry = $d->read()) ) {
	$path=$library . DIRECTORY_SEPARATOR . $entry;
	if (!is_dir($path)) continue;

	$sep = strpos($entry,'-');
	if ($sep>0) { // Bach - Variations Goldberg - Celine Frisch
		$composer=trim(substr($entry,0,$sep));
		$composer_dir=$library . DIRECTORY_SEPARATOR . $composer;
		if (!is_dir($composer_dir)) {
			mkdir($composer_dir);
		}
		rename($path,$composer_dir . DIRECTORY_SEPARATOR . $entry); // Bach\Variations Goldberg - Celine Frisch
	}
}	

die();
