<?php

// push into the game
// pull out of the game

if($_SERVER['argc'] !== 3) {
	echo "php patch.php <mode> <what>", PHP_EOL;
	exit(0);
}

list($Script,$Mode,$What) = $_SERVER['argv'];

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

$Files = [
	'effoff' => [
		'scripts\source\dse_ut2_ExternEFF.psc'
		=> 'patches\dse_ut2_ExternEFF-Off.psc',
		'scripts\dse_ut2_ExternEFF.pex'
		=> 'patches\dse_ut2_ExternEFF-Off.pex'
	],
	'effon' => [
		'scripts\source\dse_ut2_ExternEFF.psc'
		=> 'patches\dse_ut2_ExternEFF-On.psc',
		'scripts\dse_ut2_ExternEFF.pex'
		=> 'patches\dse_ut2_ExternEFF-On.pex'
	]
];

function CopyTheFiles(array $Input) {

	$Prefix = getcwd();

	foreach($Input as $Src => $Dest) {
		echo PHP_EOL, "{$Src}", PHP_EOL, "=> {$Dest}", PHP_EOL;

		copy(
			"{$Prefix}\\{$Src}",
			"{$Prefix}\\{$Dest}"
		);
	}

	return;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

if(!array_key_exists($What,$Files))
throw new Exception('invalid what');

switch($Mode) {
	case 'push':
		echo "[PUSH] {$What}", PHP_EOL;
		CopyTheFiles(array_flip($Files[$What]));
		echo PHP_EOL;
	break;
	case 'pull':
		echo "[PUSH] {$What}", PHP_EOL;
		CopyTheFiles($Files[$What]);
		echo PHP_EOL;
	break;
	default:
		throw new Exception('invalid mode');
		echo PHP_EOL;
	break;
}
