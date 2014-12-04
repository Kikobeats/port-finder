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

  get: (opts, cb) ->
    return @services unless opts
    return @_getServiceFromName opts.service, opts.protocol if opts.service?
    return @_getServiceFromPort opts.port, opts.protocol if opts.port?
    return @_getFreePorts opts.quantity, cb if opts.free?
    throw new Error "You need to specify a service."

  ## -- Private ----------------------------------------------------------------

  _readYAMLFile: (filePath) ->
    try
      yaml.safeLoad(fs.readFileSync(filePath, 'utf8'))
    catch e
      throw new Error e

  _getServiceFromName: (serviceName, protocol) ->
    service = @services[serviceName]
    if protocol?
      service[protocol] or
      throw new Error "Service '#{serviceName}' with protocol '#{protocol}' \
      doesn't found."
    else
      service or throw new Error "Service '#{serviceName}' doesn't found."

  _getServiceFromPort: (port, protocol) ->
    search = undefined
    for service of @services
      protocols = @services[service]
      if protocol?
        search = service if protocols[protocol]?
      else
        for key, value of protocols when value is port
          search = service
          break
      break if search is service

    unless search?
      unless protocol?
        return throw new Error "Service with port '#{port}' doesn't found."
      else
        return throw new Error "Service with port '#{port}' and protocol \
      '#{protocol}' doesn't found."
    search

  _getFreePorts: (quantity=1, cb) ->
    _getPort = (cb) ->
      getPort (err, port) ->
        return throw new Error err if err
        cb(port)
    ports = []
    async.until (
      -> quantity is 0
    ), ((c) ->
      _getPort (port) ->
        ports.push port
        --quantity
        c()
    ), (err) ->
      cb(ports)

## -- Exports ------------------------------------------------------------------

exports = module.exports = PortFinder
