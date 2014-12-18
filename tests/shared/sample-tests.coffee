

describe 'My Samples, with comma', ->
  describe 'Nested 1', ->
    describe 'Nested 1.1', ->
      it 'Test 1', -> expect(123).to.equal 123
      it 'Test 2', ->
      it 'Fails 1', -> expect(true).to.equal false

  describe 'Nested 2', ->
      it 'Test 3', ->
      it 'Fails on client but not on server', ->
        throw new Error('Client fail') if Meteor.isClient

      it 'Fails on server but not on client', ->
        throw new Error('Client fail') if Meteor.isServer



describe.client 'Client Only', ->
  it 'my client', ->


describe.server 'Server Only', ->
  it 'my server', ->


it 'Test has no suite', ->