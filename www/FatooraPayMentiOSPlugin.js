var exec = require('cordova/exec');

module.exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'FatooraPayMentiOSPlugin', 'coolMethod', [arg0]);
};


module.exports.initialisePaymentDetails = function(arg0,success,failure){
    exec(success,error,'FatooraPayMentiOSPlugin','initialisePaymentDetails',[arg0]);
}