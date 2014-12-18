Ctrl.define
  'tr-result-spec':
    init: ->
      @spec = @data


    api:
      clientResult: (value) -> @prop 'clientResult', value
      serverResult: (value) -> @prop 'serverResult', value

      passed: ->
        client = @api.clientResult()
        server = @api.serverResult()
        return false if client? and not client.passed
        return false if server? and not server.passed
        true


      failed: ->
        client = @api.clientResult()
        server = @api.serverResult()
        return true if client? and client.failed
        return true if server? and server.failed
        false



    helpers:
      name: ->
        Util.firstValue([@api.clientResult()?.name, @api.serverResult()?.name])


      domain: ->
        result = []
        result.push('client') if @api.clientResult()?
        result.push('server') if @api.serverResult()?
        result.join(' | ')


