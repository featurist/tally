httpism = require 'httpism'
app = require '../app'
tally = require '../tally'

find last tally () =
    tally.open collection!.find().sort( { _id = -1 } ).limit(1).to array!.0

describe 'app'
    
    server = nil
    
    before
        server := app.listen(3001)
    
    before each
        tally.open collection!.remove!
        
    after
        server.close()
    
    describe 'POST /tally'
        
        it 'creates a tally record'
            response = httpism.post! "http://localhost:3001/tally" {
                body = '{ "counter": "abc", "response": "123" }'
                headers = { 'content-type' = 'application/json' }
            }
            response.body.should.equal '{}'
            response.headers.'content-type'.should.equal 'application/json'
            record = find last tally!
            record.counter.should.equal 'abc'
            record.response.should.equal '123'
            record.created at.should.exist
        
    describe 'GET /tally/counts'

        it 'responds with grouped counts of tally records'
            tally.increment! { counter = "xyz", response = "666" }
            tally.increment! { counter = "xyz", response = "666" }
            tally.increment! { counter = "xyz", response = "999" }
            tally.increment! { counter = "ghi", response = "777" }
            expected = { "xyz" = [["666", 2], ["999", 1]], "ghi" = [["777", 1]] }
            response = httpism.get! "http://localhost:3001/tally/counts"
            response.body.should.equal (JSON.stringify(expected))
            response.headers.'content-type'.should.equal 'application/json'
