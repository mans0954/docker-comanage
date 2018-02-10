'use strict';

const confFile = $file.join($app.installdir, 'local/Config/database.php');


$app.helpers.configureDatabase = function(dbpassword) {
  $file.substitute(
    confFile, [
      {
        pattern: /SUB_PASSWORD/m,
        value: dbpassword,
      }
    ],
    {type: 'regexp'}
  );
};
