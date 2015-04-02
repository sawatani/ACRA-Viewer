module.exports = function(config) {
  config.set({

    frameworks: ['dart-unittest'],

    files: [
      'test/**/*_test.dart'
    ],

    reporters: ['progress'],

    logLevel: config.LOG_DEBUG,

    autoWatch: true,

    plugins: [
      'karma-dart',
      'karma-chrome-launcher'
    ],
    
    browsers: ['Dartium']
  });
};
