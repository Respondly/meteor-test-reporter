Package.describe({
  name: 'respondly:test-reporter',
  summary: 'Shows progress and output from a test runner.',
  version: '1.0.0',
  git: 'https://github.com/Respondly/respondly-test-reporter.git'
});



Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use(['coffeescript', 'http']);
  api.use(['templating', 'ui', 'spacebars'], 'client');
  api.use('respondly:css-stylus@1.0.3');
  api.use('respondly:ctrl@1.0.1');
  api.use('respondly:util@1.0.1');

  // Generated with: github.com/philcockfield/meteor-package-paths
  api.addFiles('client/ctrls/tr-header/tr-header.html', 'client');
  api.addFiles('client/ctrls/tr-header-tab/tr-header-tab.html', 'client');
  api.addFiles('client/ctrls/tr-header/tr-header.coffee', 'client');
  api.addFiles('client/ctrls/tr-header/tr-header.styl', 'client');
  api.addFiles('client/ctrls/tr-header-tab/tr-header-tab.coffee', 'client');
  api.addFiles('client/ctrls/tr-header-tab/tr-header-tab.styl', 'client');
  api.addFiles('client/css-mixins/test-runner.import.styl', 'client');

});

