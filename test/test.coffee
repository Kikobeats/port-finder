## -- Dependencies -------------------------------------------------------------

PortFinder = require './../src/lib/PortFinder'
should     = require 'should'

## -- Tests --------------------------------------------------------------------

describe 'PortFinder', ->

  before  -> @pf = new PortFinder()

  describe 'General', ->

    it 'read configuration file', ->
      @pf.services.echo.tcp.should.eql 7

    it 'get all services', ->
      @pf.get().echo.should.eql { tcp: 7, udp: 7 }

    it 'get port from service name that exist', ->
      @pf.get(service:'echo').should.eql {tcp: 7, udp: 7}

    it 'get port from service specifying the protocol that exist', ->
      @pf.get(service:'echo', protocol:'tcp').should.eql 7

    it 'get service from port that exist', ->
      @pf.get(port:7).should.eql 'echo'

    it 'get service from port specifying protocol that exist', ->
      @pf.get(port:7, protocol:'tcp').should.eql 'echo'

  describe 'Error Cases', ->

    it 'get port from service name that doesn\'t exist', ->
      (->
        @pf.get(service:'test')
      ).should.throw()

    it 'get port from service specifying the protocol that doesn\'t exist', ->
      (->
        @pf.get(service:'echo', protocol:'test')
      ).should.throw()

    it 'get service from port  that doesn\'t exist', ->
      (->
        @pf.get(port:9999)
      ).should.throw()

    it 'get service from port specifying protocol that doesn\'t exist', ->
      (->
        @pf.get(port:7, protocol:'test')
      ).should.throw()

  # it 'get a one free port', (done) ->
  #   @pf.free (port) ->
  #     console.log port
  #     done()

  # it 'get a more than one free port', (done) ->
  #   @pf.free 3, (ports) ->
  #     console.log ports
  #     done()
