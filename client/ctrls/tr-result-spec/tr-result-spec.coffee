Ctrl.define
  'tr-result-spec':
    api:
      clientResult: (value) -> @prop 'clientResult', value
      serverResult: (value) -> @prop 'serverResult', value



    helpers:
      name: ->
        Util.firstValue([@api.clientResult()?.name, @api.serverResult()?.name])

      domain: ->
        result = []
        result.push('client') if @api.clientResult()?
        result.push('server') if @api.serverResult()?
        result.join(' | ')

