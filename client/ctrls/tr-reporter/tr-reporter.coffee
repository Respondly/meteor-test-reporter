Ctrl.define
  'tr-reporter':
    init: ->
      @controller = PKG.TestReporterController().init(@ctrl)

    ready: ->
      @ctrl.header = @children.header
      @ctrl.results = @children.results


    destroyed: -> @controller.dispose()

    api: {}
    helpers: {}
    events: {}
