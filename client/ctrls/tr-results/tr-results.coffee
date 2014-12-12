Ctrl.define
  'tr-results':
    init: ->
    ready: ->
    destroyed: ->
    model: ->
    api:
      results: (value) -> @prop 'results', value, default:[]

    helpers:
      results: ->
        @api.results()

    events: {}
