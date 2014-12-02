/**
 * Dependencies
 */
require("coffee-script").register();
var PortFinder = require('./src/lib/PortFinder');

/**
 * Exports
 */
exports = module.exports = new PortFinder();
