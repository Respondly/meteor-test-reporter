###
The root controller for the test reporter.
###
TestReporterController = stampit().enclose ->
  ctrl = null




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

    @autorun =>
      # Calculate stats.
      mochaAggregate = Package['velocity:core'].VelocityAggregateReports.findOne({name:"mocha"})
      mochaMetadata = Package['velocity:core'].VelocityAggregateReports.findOne({name:"mochaMetadata"})
      if mochaMetadata
        total = mochaMetadata.serverTestCount + mochaMetadata.clientTestCount
      else
        total = 0
      passed = Reports.find({result: 'passed'}).count()
      failed = Reports.find({result: 'failed'}).count()

      # Update header totals.
      ctrl.header.totalPassed(passed)
      ctrl.header.totalFailed(failed)
      ctrl.header.totalTests(total)
      if total == 0
        ctrl.header.percentComplete(0)
      else
        ctrl.header.percentComplete(1.0 * (passed + failed) / total)

      # if ctrl.header.selectedTabId() == "total"
      #   ctrl.results.results(Reports.find({}))
      # else
      #   ctrl.results.results Reports.find({result: ctrl.header.selectedTabId()})

      #TODO communicate that tests are running or have finished
      # ctrl.header.setAggregateResult mochaAggregate.result

    # Sync the results filter with the selected header tab.
    @autorun =>
        filter = ctrl.header.selectedTabId()
        filter = null if filter is 'total'
        ctrl.results.filter(filter)


    # Display each new result.
    Reports.find().observe
      added: (doc) ->
        spec = PKG.Spec().init(doc)
        ctrl.results.add(spec)



    @ # Make chainable.


  # ----------------------------------------------------------------------
  return @



# Export.
PKG.TestReporterController = stampit.compose(
  Stamps.Disposable
  Stamps.AutoRun
  TestReporterController
)
