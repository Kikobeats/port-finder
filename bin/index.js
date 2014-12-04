#!/usr/bin/env node
'use strict';

/**
 * Dependencies
 */
var PortFinder = require('..');
var render     = require("compact-json").render;
var cli = require('meow')({
  pkg: "../package.json",
  help: [
      'Usage',
      '  $ portFinder [options]',
      '\n  options:',
      '\t -a\t     get all services and ports association.',
      '\t -p\t     specify the protocol.',
      '\t -f\t     get a free port.',
      '\t -n\t     specify a number of free ports.',
      '\t --version   output the current version.',
      '\n  examples:',
      '\t portFinder smtp',
      '\t portFinder 21',
      '\t portFinder -f',
      '\t portFinder -f -n 3',
  ].join('\n')
});

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}

/**
 * Commands
 */
var nFlags = Object.getOwnPropertyNames(cli.flags).length;
var nInputs = cli.input.length;
var isEmpty = nFlags === 0 && nInputs === 0;

if (isEmpty) return cli.showHelp();
// all services
if (cli.flags.a) return console.log(render(PortFinder.get()));
// free ports
if (cli.flags.f) return PortFinder.get({
  free: true,
  quantity: cli.flags.n
}, function(ports){
  console.log(render(ports));
});

// service or port
var input = cli.input[0];
var options = {};

if (isNumber(input))
  options.port = input;
else
  options.service = input;

// added protocol filter
options.protocol = cli.flags.p;

// Finally
try{
  var output = PortFinder.get(options);
  if (options.port) console.log(render({service:output}));
  else console.log(render(output));
} catch (e) {
  console.log(render({error:e.message}));
}


