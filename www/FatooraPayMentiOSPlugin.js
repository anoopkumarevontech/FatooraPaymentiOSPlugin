var exec = require('cordova/exec');



module.exports.initialisePaymentDetails = function(arg0,success,error){
    exec(success,error,'FatooraPayMentiOSPlugin','initialisePaymentDetails',[arg0]);
};

module.exports.payNow = function(arg0,success,error){
    exec(success,error,'FatooraPayMentiOSPlugin','payNow',[arg0]);
};