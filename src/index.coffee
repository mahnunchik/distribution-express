
fs = require 'fs'

###*
 *
 * Express helper
 *
 * @param {Object} options
 * @param {String} options.map Config filename, default 'distribution.json'
 * @param {Boolean} options.watch Watch changes in config file,
 * default 'false' in production environment
 * @param {Function} options.log Function for logging,
 * set to 'false' to desable logging
 * @param {Function} options.error Function for logging errors,
 * set to 'false' to desable logging
 * @throws {Error|SyntaxError} Error reading file or parsing content
 *
###

module.exports = (options={})->
  options.watch ?=  process.env.NODE_ENV != 'production'
  options.map ?= 'distribution.json'
  options.log ?= console.log
  options.error ?= console.error

  # First read config file for development and production environment
  assets = parseFile(options.map)

  # Watch changes only for development
  if options.watch == true
    watchFile options.map, ()->
      try
        assets = parseFile(options.map)
        if options.log?
          options.log "assets reloaded from file '#{options.map}'"
      catch err
        if options.error?
          options.error "error parsing file '#{options.map}'"

  # Express helper function
  return {
    helper: (key)->
      asset = assets[key]
      unless asset?
        options.error("asset '#{key}' not found") if options.error?
        return key
      return asset
    map: ()->
      return assets || {}
  }


###*
 *
 * Read file and parse content
 *
 * @name parseFile
 *
 * @param {String} filename
 * @throws {Error|SyntaxError} reading file or parsing content
 *
###

parseFile = (filename)->
  return JSON.parse(fs.readFileSync(filename, 'utf8'))

###*
 *
 * Watch file changes
 *
 * @name watchFile
 *
 * @param {String} filename
 * @param {Function} cb
 * @throws {Error} watching file
 *
###

watchFile = (filename, cb)->
  # Fix calling watch callback twice
  timeout = null
  fs.watch filename, (event) ->
    if event == 'change'
      if timeout?
        clearTimeout(timeout)
      timeout = setTimeout ()->
        timeout = null
        cb()
      , 5


