Ctrl.define
  'tr-header':
    init: ->
    ready: ->
    destroyed: ->
    model: ->
    api:
      ###
      REACTIVE: Gets or sets the propgress percentage (0..1)
      ###
      percentComplete: (value) -> @prop 'progress', value, default:0

      ###
      REACTIVE: Gets or sets the title of the test.
      ###
      title: (value) -> @prop 'title', value


      ###
      REACTIVE: Gets or sets the version of the test runner.
      ###
      version: (value) -> @prop 'version', value, default:'0.0.0'


      # Totals
      totalTests: (value) -> @prop 'totalTests', value, default:0
      totalPassed: (value) -> @prop 'totalPassed', value, default:0
      totalFailed: (value) -> @prop 'totalFailed', value, default:0




    helpers:
      cssClass: ->
        css = ''
        css += 'tr-has-failures' if @api.totalFailed() > 0
        css


      title: ->
        title = @api.title()
        right = null
        if Util.isBlank(title)
          main = 'Untitled'
        else
          parts = title.split(':')
          if parts.length is 1
            main = parts[0]
          else
            main = parts[1]
            right = title
        result =
          main: main
          right: right


      progressStyle: ->
        percent = @api.percentComplete()
        percent = Number.range(0,1).clamp(percent)
        style = "width:#{ percent * 100 }%;"
        style









    events: {}
