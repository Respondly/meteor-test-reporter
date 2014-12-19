Ctrl.define
  'tr-result-error':
    helpers:
      title: ->
        "#{ @data.domain.toUpperCase() }: #{ @data.message }"
