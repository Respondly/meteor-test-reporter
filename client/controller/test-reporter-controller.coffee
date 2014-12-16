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
    # Retrieve collections.
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

    # Sync progress.
    startedAt = null
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

        # Calculate complete percentage.
        percentComplete = if total is 0 then 0 else (1.0 * (passed + failed) / total)
        isComplete = (passed + failed) is total

        # Update header totals.
        ctrl.header.totalPassed(passed)
        ctrl.header.totalFailed(failed)
        ctrl.header.totalTests(total)
        ctrl.header.percentComplete(percentComplete)

        # Display elapsed time.
        msecs = if isComplete and startedAt
            (startedAt.millisecondsAgo() / 1000).round(2)
          else
            null
        ctrl.header.elapsedSeconds(msecs)

    # Sync the results filter with the selected header tab.
    @autorun =>
        state = ctrl.header.selectedTabId()
        state = null if state is 'total'
        filter = Object.clone(ctrl.results.filter() ? {})
        filter.state = state
        ctrl.results.filter(filter)


    # Display each new result.
    Reports.find().observe
      added: (doc) ->
        startedAt = doc.timestamp unless startedAt?
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




