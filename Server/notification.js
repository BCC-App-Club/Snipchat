var apn = require('apn');

var options = {
  token: {
    key: "AuthKey_9V33ARG2VU.p8",
    keyId: "9V33ARG2VU",
    teamId: "2YGP292648"
  },
  production: false
};
var apnProvider = new apn.Provider(options);

var deviceToken = '9ae700fa287fed4309673b3daa1c0c7e5aa7c4bbbb4c33bb7462cbd144b58650';

var notification = new apn.Notification();
notification.topic = 'azuleng.Snipchat';
notification.expiry = Math.floor(Date.now() / 1000) + 3600;
notification.badge = 3;
notification.sound = 'default';
notification.alert = 'from Team Snipchat';

apnProvider.send(notification, deviceToken).then(function(result) {
    console.log(result);
});