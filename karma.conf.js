module.exports = function(config) {
  config.set({

    frameworks: ['dart-unittest'],

    files: [
      'test/**/*_test.dart'
    ],

    reporters: ['progress', 'junit'],
    
    junitReporter: {
      outputFile: 'test/results.xml',
      suite: ''
    },

    logLevel: config.LOG_DEBUG,

    autoWatch: true,

    plugins: [
      'karma-dart',
      'karma-junit-reporter',
      'karma-chrome-launcher'
    ],
    
    browsers: ['Dartium']
  });
};
