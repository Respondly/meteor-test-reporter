Ctrl.define
  'tr-reporter':
    init: ->

    ready: ->
      @ctrl.header = @children.header
      @ctrl.results = @children.results
      @controller = PKG.TestReporterController().init(@ctrl)


    destroyed: -> @controller.dispose()

    api: {}
    helpers: {}
    events: {}
