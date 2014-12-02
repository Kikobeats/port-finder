## -- Dependencies -------------------------------------------------------------

PortFinder = require './../src/lib/PortFinder'
should     = require 'should'

## -- Tests --------------------------------------------------------------------

describe 'PortFinder', ->

  before  -> @pf = new PortFinder()

  it 'read configuration file', ->
    @pf.services.echo.tcp.should.eql 7

  it 'get all services', ->
    @pf.get().echo.should.eql { tcp: 7, udp: 7 }

  it 'get port from service name', ->
    @pf.get(service:'echo').should.eql {tcp: 7, udp: 7}

  it 'get port from service specifing the protocol', ->
    @pf.get(service:'echo', protocol:'tcp').should.eql 7

  it 'get service from port number', ->
    @pf.get(port:7).service.should.eql 'echo'

  # it 'get a one free port', (done) ->
  #   @pf.free (port) ->
  #     console.log port
  #     done()

  # it 'get a more than one free port', (done) ->
  #   @pf.free 3, (ports) ->
  #     console.log ports
  #     done()
