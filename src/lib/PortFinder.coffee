## -- Dependencies -------------------------------------------------------------

fs            = require 'fs'
path          = require 'path'
async         = require 'async'
yaml          = require 'js-yaml'
getPort       = require 'get-port'
defaultConfig = path.join(__dirname, '..', 'services.yml')

## -- Class --------------------------------------------------------------------

class PortFinder

  constructor: (configFile=defaultConfig) ->
    @services = @_readYAMLFile configFile

  get: (opts) ->
    return @services unless opts
    return @services[opts.service][opts.protocol] if opts.protocol? and opts.service?
    return @services[opts.service] if opts.service?
    return service: @_searchService(opts.port) if opts.port?
    throw new Error("You need to specify a service.")

  free: (quantity=1, cb) ->
    ports = []
    async.until (
      -> quantity is 0
    ), ((c) =>
      @_getAvailablePort (port) ->
        ports.push port
        --quantity
        c()
    ), (err) ->
      cb(ports)

  ## -- Private ----------------------------------------------------------------

  _readYAMLFile: (filePath) -> yaml.safeLoad(fs.readFileSync(filePath, 'utf8'))

  _searchService: (port) ->
    search = ''
    for service of @services
      protocols = @services[service]
      for key, value of protocols when value is port
        search = service
        break
      break if search is service
    search

  _getAvailablePort: (cb) ->
    getPort (err, port) ->
      return throw new Error err if err
      cb(port)


## -- Exports ------------------------------------------------------------------

module.exports = PortFinder
