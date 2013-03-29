mongodb = require 'mongodb'
mongo connection string = process.env.MONGOLAB_URI || 'mongodb://localhost:27017/tally'

exports.connect (callback) =
    mongodb.Db.connect (mongo connection string, callback)