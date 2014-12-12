###
The root controller for the test reporter.
###
TestReporterController = stampit().enclose ->
  ctrl = null


  @onDisposed =>
    # Run shutdown code here.
    # This is invoked after [controller.dispose()] is called.
    # console.log 'onDisposed'



  # METHODS ----------------------------------------------------------------------

  ###
  Initializes the test-reporter.
  @param ctrl: The [test-reporter] UI control.
  ###
  @init = (ctrl) =>
    Reports = Package['velocity:core'].VelocityTestReports
    Aggregates = Package['velocity:core'].VelocityAggregateReports

    #TODO
    #there's probably a better way to get the list of packages under test
    packagesUnderTest = []
    for pkg, tmp of Package
      if pkg.indexOf("local-test") == 0
        splitPkg = pkg.split(":")
        packagesUnderTest.push "#{splitPkg[1]}:#{splitPkg[2]}"
    #TODO set list of packages, not the title
    ctrl.header.title(packagesUnderTest[0])

    count = 0
    countTests = (suite)->
      count = count + (suite.tests?.length or 0)
      for suite in suite.suites
        countTests(suite)

    # MIKE: Commented out because mocha is not defined (error)
    if mocha?
      countTests(mocha?.suite)
    else
      console.error 'mocha object does not exist!!!!'

    #TODO this is only counting client tests right now
    console.log "total test count", count
    ctrl.header.totalTests count

    @autorun =>
      ctrl.header.totalPassed Reports.find({result: 'passed'}).count()
      ctrl.header.totalFailed Reports.find({result: 'failed'}).count()

      if ctrl.header.selectedTabId() == "total"
        ctrl.results.results(Reports.find({}))
      else
        ctrl.results.results Reports.find({result: ctrl.header.selectedTabId()})

    @ # Make chainable.


  # ----------------------------------------------------------------------
  return @



# Export.
PKG.TestReporterController = stampit.compose(
  Stamps.Disposable
  Stamps.AutoRun
  TestReporterController
)
