Package.describe({
  name: 'respondly:test-reporter',
  summary: 'Shows progress and output from a test runner.',
  version: '1.0.0',
  git: 'https://github.com/Respondly/respondly-test-reporter.git'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('autoupdate', 'server');
  api.use('random', 'server');
  api.use(['coffeescript', 'http']);
  api.use(['templating', 'ui', 'spacebars'], 'client');
  api.use('respondly:css-stylus@1.0.3');
  api.use('respondly:ctrl@1.0.1');
  api.use('respondly:util@1.0.1');
  api.use(['velocity:core@0.4.2']);
  api.export("Ctrl");

  // Generated with: github.com/philcockfield/meteor-package-paths
  api.addFiles('shared/ns.js', ['client', 'server']);
  api.addFiles('shared/expect.coffee', ['client', 'server']);
  api.addFiles('server/autoupdate.js', 'server');
  api.addFiles('client/ctrls/tr-header/tr-header.html', 'client');
  api.addFiles('client/ctrls/tr-header-tab/tr-header-tab.html', 'client');
  api.addFiles('client/ctrls/tr-reporter/tr-reporter.html', 'client');
  api.addFiles('client/ctrls/tr-results/tr-results.html', 'client');
  api.addFiles('client/tmpl.html', 'client');
  api.addFiles('client/ctrls/tr-header/tr-header.coffee', 'client');
  api.addFiles('client/ctrls/tr-header/tr-header.styl', 'client');
  api.addFiles('client/ctrls/tr-header-tab/tr-header-tab.coffee', 'client');
  api.addFiles('client/ctrls/tr-header-tab/tr-header-tab.styl', 'client');
  api.addFiles('client/ctrls/tr-reporter/tr-reporter.coffee', 'client');
  api.addFiles('client/ctrls/tr-reporter/tr-reporter.styl', 'client');
  api.addFiles('client/ctrls/tr-results/tr-results.coffee', 'client');
  api.addFiles('client/ctrls/tr-results/tr-results.styl', 'client');
  api.addFiles('client/controller/test-reporter-controller.coffee', 'client');
  api.addFiles('client/css-mixins/test-runner.import.styl', 'client');
  api.addFiles('client/ctrls/css.styl', 'client');
  api.addFiles('client/css.styl', 'client');

});




Package.onTest(function (api) {
  api.use(['mike:mocha-package@0.4.7', 'coffeescript']);
  api.use(['templating', 'ui', 'spacebars'], 'client');
  api.use(['respondly:util']);
  api.use('respondly:test-reporter');

  // Generated with: github.com/philcockfield/meteor-package-paths
  api.addFiles('tests/shared/_init.coffee', ['client', 'server']);
  api.addFiles('tests/shared/sample-tests.coffee', ['client', 'server']);

});
