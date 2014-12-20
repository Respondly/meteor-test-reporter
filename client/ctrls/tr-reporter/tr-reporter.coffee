Ctrl.define
  'tr-reporter':
    destroyed: -> @controller.dispose()
    ready: ->
      # Expose references to child Ctrls on the API.
      @ctrl.header = @children.header
      @ctrl.results = @children.results
      @controller = PKG.TestReporterController().init(@ctrl)

      # Handle locking the header to the top on scroll.
      do =>
          el = $(document)
          onScroll = =>
              @helpers.isHeaderFixed(el.scrollTop() > 220)
          onScroll = onScroll.throttle(50)
          el.scroll (e) -> onScroll()
          onScroll()



    api:
      isComplete: (value) -> @prop 'isComplete', value, default:false


    helpers:
      isHeaderFixed: (value) -> @prop 'isHeaderFixed', value, default:false
      cssClass: ->
        isComplete = @api.isComplete()
        css = ''
        css += 'tr-header-fixed' if @helpers.isHeaderFixed()
        css += ' tr-running' if not isComplete
        css += ' tr-complete' if isComplete
        css
