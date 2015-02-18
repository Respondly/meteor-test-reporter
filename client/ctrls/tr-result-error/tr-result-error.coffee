Ctrl.define
  'tr-result-error':
    api:
      isDetailsVisible: (value) -> @prop 'isDetailsVisible', value, default:false


    helpers:
      cssClass: ->
        css = ''
        css += 'details-visible' if @api.isDetailsVisible()
        css

      domain: -> @data.domain
      title: -> @data.message

      detailLabel: -> if @api.isDetailsVisible() then 'Less Detail' else 'More Detail'

      stackTrace: ->
        items = @data.stackTrace.split('\n').removeAt(0) # Remove the first line which is the "title".
        items.map (line) ->
            raw  = line.trim()
            raw  = raw.remove(/^at /)
            line = raw

            if line.endsWith(')')
              path = line.reverse()
              path = path.substring(1, path.indexOf('('))
              path = path.reverse()
              line = line.substring(0, line.length - path.length - 2).trim()
              path = path.remove(new RegExp("^#{ location.origin }"))

            item =
              raw: raw
              line: line
              path: path


    events:
      'click h2': -> @api.isDetailsVisible(not @api.isDetailsVisible())
