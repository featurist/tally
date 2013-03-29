db = require './db'
ObjectID = require('mongodb').ObjectID

open collection () = db.connect!.collection 'tally'

increment (record) =
    record.created at = @new Date
    open collection!.insert! (record).0

counts () =
    group = open collection!.group! (
        { counter = true, response = true }
        {}
        { count = 0 }
        "function (obj, prev) { prev.count++; }"
    )
    counters = {}
    for each @(item) in (group)
        entries = counters.(item.counter) || []
        entries.push [item.response, item.count]
        counters.(item.counter) = entries
    
    counters

exports.open collection = open collection
exports.increment = increment
exports.counts = counts
