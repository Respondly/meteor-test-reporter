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
      ###
      add: (spec) ->
        console.log '|| add', spec


    helpers:
      results: ->
        @api.results()

    events: {}
