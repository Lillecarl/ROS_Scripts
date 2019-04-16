<?php
// Credit this kinda to stackoverflow, I don't know PHP and I don't wanna know PHP. Typecasting correct? Whatever?
$length = 10/2;
$input = $_GET["length"];
if ($input && (int)$input) {
	    $length = (int)$input / 2;
}
echo bin2hex(random_bytes($length));
?>

