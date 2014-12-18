Ctrl.define
  'tr-results':
    api:
      ###
      Adds a new test result.
      @param spec: The test result model.
      @param callback: Invoked upon completion.
      ###
      add: (spec, callback) ->

        insertSuite = (suite, callback) =>
              # Create a queue for callbacks.
              # This is to ensure that suite-ctrls are not inserted multiple
              # times while the first suite Ctrl is loading.
              suite.insertCallbacks ?= []
              suite.insertCallbacks.push(callback)
              done = (ctrl) =>
                  suite.insertCallbacks.each (func) -> func(suite.ctrl)
                  suite.insertCallbacks = []

              return if suite?.isLoading
              return done() if not suite?
              return done() if suite.ctrl? and not suite.isLoading
              suite.isLoading = true

              appendCtrl = (suiteCtrl) =>
                  el = if suiteCtrl? then suiteCtrl.elSuites() else @el()
                  suite.ctrl = ctrl = @appendCtrl('tr-result-suite', el, data:suite)
                  ctrl.onReady =>
                      suite.isLoading = false
                      done()

              if parentSuite = suite.parentSuite
                # Recursively insert all parent suites.
                insertSuite suite.parentSuite, (suiteCtrl) => appendCtrl(suiteCtrl)
              else
                appendCtrl()

        # Ensure the contianing suite elements are inserted
        # then render the spec.
        insertSuite spec.parentSuite, (suiteCtrl) =>
            suiteCtrl.addSpec(spec)
            callback?()



      ###
      Clears the test results.
      ###
      clear: ->
        for suiteCtrl in @findChildren('tr-result-suite')
          suiteCtrl.dispose()





