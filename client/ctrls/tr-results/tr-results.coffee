Ctrl.define
  'tr-results':
    init: ->


    api:
      ###
      REACTIVE: Gets or sets the top-level filter to apply to the result set.
      ###
      filter: (value) -> @prop 'filter', value, default:null


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

            appendCtrl = (parentCtrl) =>
                el = if parentCtrl? then parentCtrl.el() else @el()
                suite.ctrl = ctrl = @appendCtrl('tr-result-suite', el, data:suite)
                ctrl.onReady =>
                    suite.isLoading = false
                    done()


            if parentSuite = suite.parentSuite
              insertSuite suite.parentSuite, (parentCtrl) => appendCtrl(parentCtrl)

            else
              appendCtrl()


        insertSuite spec.parentSuite, (suiteCtrl) =>
          callback?()




    helpers:
      results: ->
        @api.results()

    events: {}
