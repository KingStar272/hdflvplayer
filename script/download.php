<?php
$filename = $_GET['f'];
echo $filename;
header('Content-disposition: attachment; filename='.basename($filename));
readfile($filename);
?>