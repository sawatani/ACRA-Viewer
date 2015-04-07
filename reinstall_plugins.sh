rm -rf platforms/
rm -rf plugins/
mkdir -vp plugins

cordova platform add android
[ -n "$(uname | grep 'Darwin')" ] && cordova platform add ios

# Default plugins
cordova plugin add org.apache.cordova.device
cordova plugin add org.apache.cordova.console
cordova plugin add org.apache.cordova.camera
cordova plugin add org.apache.cordova.splashscreen
cordova plugin add org.apache.cordova.statusbar
cordova plugin add org.apache.cordova.geolocation

# Create Icons and Splash Screens
ionic resources
