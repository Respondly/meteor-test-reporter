Ctrl.define
  'tr-reporter':
    init: ->
    ready: ->
    destroyed: ->
    model: ->

    api:
      header: -> @children.header
      results: -> @children.results

    helpers: {}
    events: {}
