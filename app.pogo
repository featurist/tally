express = require 'express'
tally = require './tally'

app = express()
app.use(express.static('./public'))
app.use(express.body parser())

exports.listen (port) =

    app.post '/tally' @(req, res)
        tally.increment (req.body) @(err)
            res.set header 'content-type' 'application/json'
            res.end '{}'
    
    app.get '/tally/counts' @(req, res)
        tally.counts @(err, counts)
            res.set header 'content-type' 'application/json'
            res.end (JSON.stringify(counts))
        
    app.listen(port, "0.0.0.0")
