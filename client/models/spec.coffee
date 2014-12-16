###
Represents the results of a single test.
###
PKG.Spec = stampit().enclose ->
  doc = null


  # ----------------------------------------------------------------------


  ###
  Initializes the spec with the Velocity result document.
  @param document: The Velocity document.
  ###
  @init = (document) ->
    # Store state.
    doc = document
    ancestors = doc.ancestors
    @name = doc.name
    @parentSuite = PKG.Suite.findOrCreate(ancestors)
    throw new Error('Must have a parent suite') unless @parentSuite

    # Add this spec to the parent suite.
    @parentSuite.childSpecs.push(@)
    @parentSuite.childSpecs.total(@parentSuite.childSpecs.total() + 1)

    # Finish up.
    return @



  # ----------------------------------------------------------------------
  return @

