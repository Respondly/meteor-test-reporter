Ctrl.define
  'tr-result-error':
    helpers:
      domain: -> @data.domain
      title: -> @data.message

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
