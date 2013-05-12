require('coffee-script');
require('./server/launch');

process.on('uncaughtException', function (exception) {
   console.trace("uncaught");
   console.error(exception);
});