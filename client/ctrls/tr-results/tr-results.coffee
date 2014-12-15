Ctrl.define
  'tr-results':
    init: ->

    api:
      results: (value) -> @prop 'results', value, default:[]

      ###
      REACTIVE: Gets or sets the top-level filter to apply to the result set.
      ###
      filter: (value) -> @prop 'filter', value, default:null


      ###
      Adds a new test result.
      @param doc: The Velocity test result document.
      ###
      add: (doc) ->
        console.log '|| add', doc


    helpers:
      results: ->
        @api.results()

    events: {}
