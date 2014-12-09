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



    helpers:

      title: ->
        title = @api.title()
        title = 'Untitled' if Util.isBlank(title)
        title

      progressStyle: ->
        percent = @api.percentComplete()
        percent = Number.range(0,1).clamp(percent)
        style = "width:#{ percent * 100 }%;"
        style






    events: {}
