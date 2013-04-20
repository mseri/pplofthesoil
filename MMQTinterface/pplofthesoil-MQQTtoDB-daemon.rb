require 'rubygems'        # if you use RubyGems
require 'daemons'
require 'pplofthesoil-listen'

# copied from pplofthesoil-listen
logFileD = 'D.puts.soil.log'
brokerAddressD = 'm2m.eclipse.org'
dataManagerAddressD = 'http://soil-sample-api.herokuapp.com/soil_samples'
CLIDebugLevelD = 1

listenToMQTTForSoilData(brokerAddressD,dataManagerAddressD,logFileD,CLIDebugLevelD)

# Become a daemon
Daemons.daemonize

# The server loop
loop {
  conn = accept_conn()
  serve(conn)
}
