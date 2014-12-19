LOREM = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo.'

describe 'My Samples, with comma', ->
  describe 'Nested 1', ->
    describe 'Nested 1.1', ->
      it 'Test 1', -> expect(123).to.equal 123
      it 'Test 2', ->
      it 'Fails 1', -> expect(true).to.equal false
      it "Has a really long name #{ LOREM }", ->

      describe "Nested suite with a really long name #{ LOREM }", ->
        it 'Test that passes', ->

        it 'Async test', (done) ->
          Util.delay 1752, => done()


  describe 'Nested 2', ->
      it 'Test 3', ->
      it 'Fails on client but not on server', ->
        throw new Error('Client fail') if Meteor.isClient

      it 'Fails on server but not on client', ->
        throw new Error('Client fail') if Meteor.isServer



describe.client 'Client Only', ->
  it 'my client', ->
  it "Has a really long name on the client #{ LOREM }", ->


describe.server 'Server Only', ->
  it 'my server', ->
  it "Has a really long name on the server #{ LOREM }", ->


it 'Test has no suite', ->