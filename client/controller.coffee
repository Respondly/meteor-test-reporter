###
The root controller for the test reporter.
###
TestReporterController = stampit().enclose ->
  ctrl = null
  hash = new ReactiveHash(onlyOnChange:true)


  # METHODS ----------------------------------------------------------------------

  @isComplete = (value) -> hash.prop 'isComplete', value, default:false


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
    showElapsedTime = =>
          startedAt = Reports.find({}, sort:{timestamp:1}).fetch()[0]?.timestamp
          if startedAt
            seconds = (startedAt.millisecondsAgo() / 1000).round(1)
          else
            seconds = 0
          ctrl.header.elapsedSeconds(seconds)

          # Loop on a timer if not complete.
          if not @isComplete()
            Util.delay 100, => showElapsedTime()

    showElapsedTime()

    @autorun =>
      isComplete = @isComplete()
      ctrl.isComplete(isComplete)
      showElapsedTime() if isComplete


    # Display results.
    @autorun =>
        # Calculate stats.
        mochaAggregate = Aggregates.findOne({name:"mocha"})
        mochaMetadata = Aggregates.findOne({name:"mochaMetadata"})
        aggregateCompleted = Aggregates.findOne({name: 'aggregateComplete'})
        aggregateResult = Aggregates.findOne({name: 'aggregateResult'})
        if mochaMetadata
          total = mochaMetadata.serverTestCount + mochaMetadata.clientTestCount
        else
          total = 0
        passed = Reports.find({result: 'passed'}).count()
        failed = Reports.find({result: 'failed'}).count()

        # Calculate complete percentage.
        percentComplete = if total is 0 then 0 else (1.0 * (passed + failed) / total)
        isComplete = aggregateCompleted?.result == "completed"
        @isComplete(isComplete) # Store in reactive property.

        # Store data attributes.
        if aggregateCompleted
          $(document.body).attr("data-completed", "#{ isComplete }")
        if aggregateResult
          $(document.body).attr("data-result", "#{ aggregateResult.result }")

        # Update header totals.
        ctrl.header.totalPassed(passed)
        ctrl.header.totalFailed(failed)
        ctrl.header.totalTests(total)
        ctrl.header.percentComplete(percentComplete)



    # Load results.
    resultsHandle = null
    loadResults = (selector) =>
        addResult = (doc) =>
              spec = PKG.Spec().init(doc)
              ctrl.results.add(spec)

        isComplete = @isComplete()
        resultsHandle?.stop() if isComplete

        cursor = Reports.find(selector)
        if isComplete
          # The test run is already complete. Load the items manually.
          addResult(doc) for doc in cursor.fetch()

        else
          # Display each new result as it arrives.
          resultsHandle?.stop()
          resultsHandle = cursor.observe
            added: (doc) -> addResult(doc)

    getSelector = ->
        tabId = ctrl.header.selectedTabId()
        selector = {}
        selector.result = tabId unless tabId is 'total'
        selector

    # Sync the results filter with the selected header tab.
    @autorun =>
        selector = getSelector()
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




