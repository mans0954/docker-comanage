<?php
class DATABASE_CONFIG {

	public $default = array(
		'datasource' => 'Database/Postgres',
		'persistent' => false,
		'host' => 'postgres',
		'login' => 'comanage',
		'password' => 'comanage',
		'database' => 'comanage',
		'prefix' => 'cm_',
		//'encoding' => 'utf8',
	);

	public $test = array(
		'datasource' => 'Database/Postgres',
		'persistent' => false,
		'host' => 'postgres',
		'login' => 'comange',
		'password' => 'comanage',
		'database' => 'test_comanage',
		'prefix' => 'cm_',
		//'encoding' => 'utf8',
	);
}
?>
