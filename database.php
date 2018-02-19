<?php
class DATABASE_CONFIG {

	public $default = array();
/*
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
*/

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
	function __construct() {
		$this->default = yaml_parse_file('/etc/comanage/database.yaml');
                $this->default['password'] = 'SUB_PASSWORD';
	}
}
?>
