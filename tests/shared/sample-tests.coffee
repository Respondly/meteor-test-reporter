

describe 'My Samples, with comma', ->
  describe 'Nested 1', ->
    describe 'Nested 1.1', ->
      it 'Test 1', -> expect(123).to.equal 123
      it 'Test 2', ->

  describe 'Nested 2', ->
      it 'Test 3', ->



describe.client 'Client Only', ->
  it 'my client', ->


describe.server 'Server Only', ->
  it 'my server', ->


it 'Test has no suite', ->