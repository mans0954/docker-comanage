'use strict';

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
