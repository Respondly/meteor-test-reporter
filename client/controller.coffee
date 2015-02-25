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
          startedAt = Aggregates.findOne({name: "mochaMetadata"})?.start
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
      showElapsedTime() if isComplete


    # Display results.
    @autorun =>
        testDescs = {}

        # Calculate stats.
        mochaAggregate = Aggregates.findOne({name:"mocha"})
        mochaMetadata = Aggregates.findOne({name:"mochaMetadata"})
        aggregateCompleted = Aggregates.findOne({name: 'aggregateComplete'})
        aggregateResult = Aggregates.findOne({name: 'aggregateResult'})
        if mochaMetadata
          #this is run an awful lot, might want to cache
          mochaMetadata.serverTests?.forEach (serverTest)->
            testDescs[serverTest] = testDescs[serverTest] or {}
            testDescs[serverTest].server = true
          mochaMetadata.clientTests?.forEach (clientTest)->
            testDescs[clientTest] = testDescs[clientTest] or {}
            testDescs[clientTest].client = true
          total = _.keys(testDescs).length
        else
          total = 0

        totals = {}
        Reports.find({result: 'pending'}).forEach (rep)->
          totals[rep.fullName] = 'skipped'
        Reports.find({result: 'passed'}).forEach (rep)->
          #its not passing until it passes both client and server
          if rep.isClient
            if testDescs[rep.fullName]?.server
              totals[rep.fullName] = 'half-finished'
            else
              totals[rep.fullName] = 'passed'
          else #server test
            totals[rep.fullName] = "passed"

        Reports.find({result: 'failed'}).forEach (rep)->
          totals[rep.fullName] = 'failed'

        [passed, failed, skipped] = [0,0,0]
        _.values(totals).forEach (result)->
          passed +=1 if result == "passed"
          failed +=1 if result == "failed"
          skipped +=1 if result == "skipped"

        # Calculate complete percentage.
        percentComplete = if total is 0 then 0 else (1.0 * (passed + failed + skipped) / total)
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
        ctrl.header.totalSkipped(skipped)
        ctrl.header.totalTests(total)
        ctrl.header.percentComplete(percentComplete)


    # Load results.
    do =>
        addResult = (doc) => ctrl.results.add(doc)

        queue = []
        renderQueue = =>
              docs = Object.clone(queue)
              queue = []
              addResult(doc) for doc in docs
              if not @isComplete()
                Util.delay 500, => renderQueue()
        renderQueue()

        resultsHandle = null
        loadResults = (selector) =>

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
                added: (doc) -> queue.push(doc)


        # Sync the results filter with the selected header tab.
        @autorun =>
            tabId = ctrl.header.selectedTabId()
            selector = {}
            selector.result = tabId unless tabId is 'total'
            if tabId == "skipped"
              selector.result = "pending"
            selector

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
