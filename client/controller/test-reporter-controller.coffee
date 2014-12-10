###
The root controller for the test reporter.
###
TestReporterController = stampit().enclose ->
  ctrl = null


  @onDisposed =>
    # Run shutdown code here.
    # This is invoked after [controller.dispose()] is called.
    console.log 'onDisposed'



  # METHODS ----------------------------------------------------------------------

  ###
  Initializes the test-reporter.
  @param ctrl: The [test-reporter] UI control.
  ###
  @init = (ctrl) =>

    console.log 'Controller initialized'
    console.log 'ctrl', ctrl
    console.log ''

    @autorun =>
        # Use autoruns from the [this] object
        # so they are safely shutdown when the controller
        # is disposed.


    @ # Make chainable.


  # ----------------------------------------------------------------------
  return @



# Export.
PKG.TestReporterController = stampit.compose(
  Stamps.Disposable
  Stamps.AutoRun
  TestReporterController
)