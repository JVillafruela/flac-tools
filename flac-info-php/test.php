<?php 
// composer  require bluemoehre/flac-php:dev-master
require 'vendor/autoload.php';

use bluemoehre\Flac;


// benchmark start
$t = microtime(true);

$flac = new Flac('M:\audio\flac\Bach\Bach - Brandenburg Concertos - Kuijken\CD1\01 Brandenburg Concerto No. 1 in F major, BWV 1046- I. Allegro.flac');
//var_dump($flac);
// benchmark end
$t = microtime(true) - $t;

echo 'Benchmark: ' . $t .'s' . "\n\n";
echo 'Filename: ' . $flac->getFileName() . "\n";
echo 'File size: ' . $flac->getFileSize() . " Bytes\n";
echo 'Meta-Blocks: '; print_r($flac->getMetadataBlockCounts()); echo "\n";
echo 'Sample Rate: ' . $flac->getSampleRate() . "\n";
echo 'Channels: ' . $flac->getChannels() . "\n";
echo 'Bits per sample: ' . $flac->getBitsPerSample() . "\n";
echo 'Total samples: ' . $flac->getTotalSamples() . "\n";
echo 'Duration: ' . $flac->getDuration() . " s\n";
echo 'MD5 checksum (audio data): ' . $flac->getAudioMd5() . "\n";
echo 'Vorbis-Comment: ';  echo "\n";

foreach ($flac->getVorbisComment()['comments']  as $tag => $val) {
    echo $tag .' : '. join(',', $val) . "\n";
}
