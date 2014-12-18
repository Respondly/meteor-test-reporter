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
    resultsHandle = null
    isComplete = false

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
    # startedAt = null

    showElapsedTime = ->
        startedAt = Reports.find({}, sort:{timestamp:1}).fetch()[0]?.timestamp
        if startedAt
          seconds = (startedAt.millisecondsAgo() / 1000).round(2)
        else
          seconds = null
        ctrl.header.elapsedSeconds(seconds)



    # Display results.
    @autorun =>
        # Calculate stats.
        mochaAggregate = Aggregates.findOne({name:"mocha"})
        mochaMetadata = Aggregates.findOne({name:"mochaMetadata"})
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

        if isComplete
          showElapsedTime()
          resultsHandle?.stop()




    loadResults = (selector) ->

        addResult = (doc) ->
            spec = PKG.Spec().init(doc)
            ctrl.results.add(spec)

        loadViaObserve = not isComplete
        loadViaObserve = true

        console.warn 'TODO - Load manually once isComplete is reliably retrieved, which should be once the report data is available.'
        console.warn 'NOTE: Changing the filter tab will not work until this is done.'
        console.log ''

        cursor = Reports.find(selector)
        if loadViaObserve
          # Display each new result as it arrives.
          resultsHandle?.stop()
          resultsHandle = cursor.observe
            added: (doc) -> addResult(doc)

        else
          # The test run is already complete. Load the items manually.
          for doc in cursor.fetch()
            addResult(doc)



    # Sync the results filter with the selected header tab.
    @autorun =>
        # Derive the query filter.
        tabId = ctrl.header.selectedTabId()
        selector = {}
        selector.result = tabId unless tabId is 'total'
        ctrl.results.clear()
        Util.delay => loadResults(selector)


    return @ # Make chainable.


  # ----------------------------------------------------------------------
  return @



# Export.
PKG.TestReporterController = stampit.compose(
  Stamps.Disposable
  Stamps.AutoRun
  TestReporterController
)




